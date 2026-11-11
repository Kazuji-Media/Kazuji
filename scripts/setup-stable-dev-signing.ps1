#requires -Version 5.1
<#
.SYNOPSIS
Creates the dedicated Stable Dev keystore and uploads only the five DEV_* GitHub Actions secrets.

.PARAMETER Repository
Must be Kazuji-Media/Kazuji; this script refuses other repositories.

.PARAMETER BackupDirectory
Secure backup directory outside this repository for the Dev keystore and an encrypted credential backup.
Store the backup passphrase in Dashlane; it is required to restore the signing identity.

.PARAMETER Resume
Restores or reuses the Dev signing identity from the encrypted backup and re-uploads its secrets after confirmation.

.EXAMPLE
.\scripts\setup-stable-dev-signing.ps1 -Repository Kazuji-Media/Kazuji -BackupDirectory C:\SecureBackup\KazujiDev
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$')]
    [string]$Repository,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$BackupDirectory,

    [switch]$Resume
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
    throw 'Este script de configuração da assinatura precisa ser executado no Windows.'
}
if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
    throw 'A variável LOCALAPPDATA não está definida.'
}
$expectedRepository = 'Kazuji-Media/Kazuji'
if ($Repository -ine $expectedRepository) {
    throw "Este script só pode configurar a assinatura Dev de $expectedRepository."
}
$Repository = $expectedRepository
$SigningProfile = 'kazuji-dev'
$KeyAlias = 'kazuji-dev'
$DistinguishedName = 'CN=Kazuji Dev, O=Kazuji'
$KeystoreSecretName = 'DEV_KEYSTORE_BASE64'
$StorePasswordSecretName = 'DEV_KEYSTORE_PASSWORD'
$KeyAliasSecretName = 'DEV_KEY_ALIAS'
$KeyPasswordSecretName = 'DEV_KEY_PASSWORD'
$CertificateSha256SecretName = 'DEV_CERT_SHA256'
$secretNames = @(
    $KeystoreSecretName,
    $StorePasswordSecretName,
    $KeyAliasSecretName,
    $KeyPasswordSecretName,
    $CertificateSha256SecretName
)
$uniqueSecretNames = @($secretNames | Select-Object -Unique)
if ($uniqueSecretNames.Count -ne 5) {
    throw 'Os cinco nomes de GitHub secret precisam ser distintos.'
}

$ghCommand = Get-Command gh -CommandType Application -ErrorAction Stop | Select-Object -First 1
$keytoolCommand = Get-Command keytool -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
if ($null -eq $keytoolCommand -and -not [string]::IsNullOrWhiteSpace($env:JAVA_HOME)) {
    $keytoolCandidate = Join-Path $env:JAVA_HOME 'bin\keytool.exe'
    if (Test-Path -LiteralPath $keytoolCandidate -PathType Leaf) {
        $keytoolCommand = [pscustomobject]@{ Source = $keytoolCandidate }
    }
}
if ($null -eq $keytoolCommand) {
    throw 'keytool não foi encontrado. Instale um JDK 17+ e adicione JAVA_HOME\bin ao PATH.'
}

$signingDirectory = Join-Path (Join-Path $env:LOCALAPPDATA 'Kazuji') 'signing'
$keystoreBaseName = 'kazuji-dev'
$keystorePath = Join-Path $signingDirectory "$keystoreBaseName.p12"
$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$repositoryRoot = $repositoryRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
$repositoryRootPrefix = $repositoryRoot + [IO.Path]::DirectorySeparatorChar
$backupDirectoryFull = [IO.Path]::GetFullPath($BackupDirectory)
if ($backupDirectoryFull.Equals($repositoryRoot, [StringComparison]::OrdinalIgnoreCase) -or
    $backupDirectoryFull.StartsWith($repositoryRootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'O backup da keystore precisa ficar fora do repositório.'
}
$currentPath = $backupDirectoryFull
while (-not [string]::IsNullOrWhiteSpace($currentPath)) {
    if (Test-Path -LiteralPath $currentPath) {
        $pathItem = Get-Item -LiteralPath $currentPath -Force
        if (($pathItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "O caminho de backup não pode atravessar um link ou junction: $currentPath"
        }
    }
    $parentPath = Split-Path -Path $currentPath -Parent
    if ($parentPath -eq $currentPath) {
        break
    }
    $currentPath = $parentPath
}
$keystoreBackupPath = Join-Path $backupDirectoryFull "$keystoreBaseName.p12"
$portableCredentialBackupPath = Join-Path $backupDirectoryFull "$keystoreBaseName.credentials.json.enc"
$keyAlias = $KeyAlias
$storePasswordEnvironmentVariable = 'KAZUJI_DEV_STORE_PASSWORD'
$keyPasswordEnvironmentVariable = 'KAZUJI_DEV_KEY_PASSWORD'
$passwordIterations = 600000

function ConvertFrom-SecureStringValue {
    param([Parameter(Mandatory = $true)][Security.SecureString]$SecureText)

    $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureText)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
    }
}

function New-RandomPassword {
    $bytes = New-Object byte[] 32
    $random = [Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $random.GetBytes($bytes)
        return [Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_')
    }
    finally {
        [Array]::Clear($bytes, 0, $bytes.Length)
        $random.Dispose()
    }
}

function Read-BackupPassphrase {
    param([switch]$Confirm)

    $secureText = $null
    $confirmation = $null
    try {
        $secureText = Read-Host 'Senha mestra do backup (salve no Dashlane; entrada oculta)' -AsSecureString
        if ($secureText.Length -lt 24) {
            throw 'Use uma senha mestra aleatória de pelo menos 24 caracteres guardada no Dashlane.'
        }
        $passphrase = ConvertFrom-SecureStringValue $secureText
        if ($Confirm) {
            $confirmation = Read-Host 'Repita a senha mestra do backup (entrada oculta)' -AsSecureString
            $confirmedPassphrase = ConvertFrom-SecureStringValue $confirmation
            if ($passphrase -cne $confirmedPassphrase) {
                throw 'As senhas mestras não coincidem.'
            }
            $confirmedPassphrase = $null
        }
        return $passphrase
    }
    finally {
        if ($null -ne $secureText) {
            $secureText.Dispose()
        }
        if ($null -ne $confirmation) {
            $confirmation.Dispose()
        }
    }
}

function Get-BackupKeyMaterial {
    param(
        [Parameter(Mandatory = $true)][string]$Passphrase,
        [Parameter(Mandatory = $true)][byte[]]$Salt
    )

    $deriver = [Security.Cryptography.Rfc2898DeriveBytes]::new($Passphrase, $Salt, $passwordIterations)
    try {
        return $deriver.GetBytes(64)
    }
    finally {
        $deriver.Dispose()
    }
}

function ConvertTo-EncryptedCredentialBackup {
    param(
        [Parameter(Mandatory = $true)][string]$Passphrase,
        [Parameter(Mandatory = $true)][string]$Plaintext
    )

    $salt = New-Object byte[] 16
    $iv = New-Object byte[] 16
    $random = [Security.Cryptography.RandomNumberGenerator]::Create()
    $keyMaterial = $null
    $encryptionKey = New-Object byte[] 32
    $authenticationKey = New-Object byte[] 32
    $aes = $null
    $hmac = $null
    $plaintextBytes = $null
    try {
        $random.GetBytes($salt)
        $random.GetBytes($iv)
        $keyMaterial = Get-BackupKeyMaterial -Passphrase $Passphrase -Salt $salt
        [Array]::Copy($keyMaterial, 0, $encryptionKey, 0, 32)
        [Array]::Copy($keyMaterial, 32, $authenticationKey, 0, 32)
        $plaintextBytes = [Text.Encoding]::UTF8.GetBytes($Plaintext)
        $aes = [Security.Cryptography.Aes]::Create()
        $aes.KeySize = 256
        $aes.BlockSize = 128
        $aes.Mode = [Security.Cryptography.CipherMode]::CBC
        $aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
        $aes.Key = $encryptionKey
        $aes.IV = $iv
        $encryptor = $aes.CreateEncryptor()
        try {
            $ciphertext = $encryptor.TransformFinalBlock($plaintextBytes, 0, $plaintextBytes.Length)
        }
        finally {
            $encryptor.Dispose()
        }

        $saltBase64 = [Convert]::ToBase64String($salt)
        $ivBase64 = [Convert]::ToBase64String($iv)
        $ciphertextBase64 = [Convert]::ToBase64String($ciphertext)
        $authenticatedData = "1|PBKDF2-HMAC-SHA1|$passwordIterations|$saltBase64|$ivBase64|$ciphertextBase64"
        $hmac = [Security.Cryptography.HMACSHA256]::new($authenticationKey)
        $authenticationTag = [Convert]::ToBase64String(
            $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($authenticatedData))
        )
        $document = [ordered]@{
            formatVersion = 1
            kdf = 'PBKDF2-HMAC-SHA1'
            iterations = $passwordIterations
            salt = $saltBase64
            iv = $ivBase64
            ciphertext = $ciphertextBase64
            authenticationTag = $authenticationTag
        }
        return $document | ConvertTo-Json -Compress
    }
    finally {
        $random.Dispose()
        if ($null -ne $aes) { $aes.Dispose() }
        if ($null -ne $hmac) { $hmac.Dispose() }
        if ($null -ne $keyMaterial) { [Array]::Clear($keyMaterial, 0, $keyMaterial.Length) }
        [Array]::Clear($encryptionKey, 0, $encryptionKey.Length)
        [Array]::Clear($authenticationKey, 0, $authenticationKey.Length)
        if ($null -ne $plaintextBytes) { [Array]::Clear($plaintextBytes, 0, $plaintextBytes.Length) }
    }
}

function ConvertFrom-EncryptedCredentialBackup {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Passphrase
    )

    $document = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    if ($document.formatVersion -ne 1 -or $document.kdf -cne 'PBKDF2-HMAC-SHA1' -or
        $document.iterations -ne $passwordIterations) {
        throw 'O formato do backup criptografado não é compatível.'
    }
    $salt = [Convert]::FromBase64String([string]$document.salt)
    $iv = [Convert]::FromBase64String([string]$document.iv)
    $ciphertext = [Convert]::FromBase64String([string]$document.ciphertext)
    $providedTag = [Convert]::FromBase64String([string]$document.authenticationTag)
    if ($salt.Length -ne 16 -or $iv.Length -ne 16 -or $ciphertext.Length -eq 0 -or
        ($ciphertext.Length % 16) -ne 0 -or $providedTag.Length -ne 32) {
        throw 'O backup criptografado está incompleto ou corrompido.'
    }

    $keyMaterial = Get-BackupKeyMaterial -Passphrase $Passphrase -Salt $salt
    $encryptionKey = New-Object byte[] 32
    $authenticationKey = New-Object byte[] 32
    $aes = $null
    $hmac = $null
    $plaintextBytes = $null
    try {
        [Array]::Copy($keyMaterial, 0, $encryptionKey, 0, 32)
        [Array]::Copy($keyMaterial, 32, $authenticationKey, 0, 32)
        $saltBase64 = [Convert]::ToBase64String($salt)
        $ivBase64 = [Convert]::ToBase64String($iv)
        $ciphertextBase64 = [Convert]::ToBase64String($ciphertext)
        $authenticatedData = "1|PBKDF2-HMAC-SHA1|$passwordIterations|$saltBase64|$ivBase64|$ciphertextBase64"
        $hmac = [Security.Cryptography.HMACSHA256]::new($authenticationKey)
        $expectedTag = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($authenticatedData))
        $tagDifference = 0
        for ($i = 0; $i -lt $expectedTag.Length; $i++) {
            $tagDifference = $tagDifference -bor ($expectedTag[$i] -bxor $providedTag[$i])
        }
        if ($tagDifference -ne 0) {
            throw 'Senha mestra incorreta ou backup criptografado adulterado.'
        }

        $aes = [Security.Cryptography.Aes]::Create()
        $aes.KeySize = 256
        $aes.BlockSize = 128
        $aes.Mode = [Security.Cryptography.CipherMode]::CBC
        $aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
        $aes.Key = $encryptionKey
        $aes.IV = $iv
        $decryptor = $aes.CreateDecryptor()
        try {
            $plaintextBytes = $decryptor.TransformFinalBlock($ciphertext, 0, $ciphertext.Length)
        }
        finally {
            $decryptor.Dispose()
        }
        $plaintext = [Text.UTF8Encoding]::new($false, $true).GetString($plaintextBytes)
        return $plaintext | ConvertFrom-Json
    }
    finally {
        if ($null -ne $aes) { $aes.Dispose() }
        if ($null -ne $hmac) { $hmac.Dispose() }
        [Array]::Clear($keyMaterial, 0, $keyMaterial.Length)
        [Array]::Clear($encryptionKey, 0, $encryptionKey.Length)
        [Array]::Clear($authenticationKey, 0, $authenticationKey.Length)
        if ($null -ne $plaintextBytes) { [Array]::Clear($plaintextBytes, 0, $plaintextBytes.Length) }
    }
}

& $ghCommand.Source auth status --hostname github.com
if ($LASTEXITCODE -ne 0) {
    throw 'Faça login no GitHub CLI primeiro: gh auth login'
}

$resolvedRepository = & $ghCommand.Source repo view $Repository --json nameWithOwner --jq '.nameWithOwner'
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace(($resolvedRepository | Out-String).Trim())) {
    throw "Não foi possível acessar o repositório $Repository com a conta autenticada no gh."
}
$Repository = ($resolvedRepository | Out-String).Trim()

$existingSecretNames = @(& $ghCommand.Source secret list --repo $Repository --json name --jq '.[].name')
if ($LASTEXITCODE -ne 0) {
    throw "Não foi possível listar os secrets de Actions em $Repository."
}
$existingSigningSecrets = @($existingSecretNames | Where-Object { $secretNames -contains $_ })
$hasKeystore = Test-Path -LiteralPath $keystorePath -PathType Leaf
$hasKeystoreBackup = Test-Path -LiteralPath $keystoreBackupPath -PathType Leaf
$hasPortableCredentialBackup = Test-Path -LiteralPath $portableCredentialBackupPath -PathType Leaf

if ($Resume) {
    if (-not ($hasKeystoreBackup -and $hasPortableCredentialBackup)) {
        throw "Para retomar, mantenha a keystore e o backup criptografado em $backupDirectoryFull."
    }
}
elseif ($hasKeystore -or $hasKeystoreBackup -or $hasPortableCredentialBackup) {
    throw "Já existem arquivos de assinatura. Use -Resume para reutilizar a mesma chave."
}

Write-Host "Repositório GitHub: $Repository"
Write-Host "Keystore local: $keystorePath"
Write-Host "Cópia da keystore: $keystoreBackupPath"
Write-Host "Backup criptografado de credenciais: $portableCredentialBackupPath"
Write-Host ("Serão enviados cinco secrets DEV_*: " + ($secretNames -join ', '))

if ($Resume) {
    if ($existingSigningSecrets.Count -gt 0) {
        Write-Host "Secrets existentes a reenviar com a mesma chave: $($existingSigningSecrets -join ', ')"
    }
    $confirmation = Read-Host 'O script reenviará os cinco secrets da mesma chave. Digite UPLOAD'
    if ($confirmation -cne 'UPLOAD') {
        throw 'Reenvio cancelado.'
    }
}
else {
    if ($existingSigningSecrets.Count -gt 0) {
        throw "Secrets DEV_* já existem. Nada foi alterado. Use -Resume apenas para reenviar a mesma chave local."
    }
    $confirmation = Read-Host 'O script criará uma nova chave Dev e enviará DEV_* ao GitHub. Digite CREATE'
    if ($confirmation -cne 'CREATE') {
        throw 'Operação cancelada.'
    }
}

function Set-GitHubSecretFromStdin {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Value
    )

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $ghCommand.Source
    $startInfo.Arguments = "secret set $Name --repo $Repository"
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    try {
        if (-not $process.Start()) {
            throw "Não foi possível iniciar gh para definir o secret $Name."
        }
        $stdoutTask = $process.StandardOutput.ReadToEndAsync()
        $stderrTask = $process.StandardError.ReadToEndAsync()
        $process.StandardInput.Write($Value)
        $process.StandardInput.Close()
        $process.WaitForExit()
        $null = $stdoutTask.GetAwaiter().GetResult()
        $stderr = $stderrTask.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) {
            $errorDetail = ($stderr | Out-String).Trim()
            throw "gh não conseguiu definir o secret $Name (código $($process.ExitCode)). $errorDetail"
        }
    }
    finally {
        $process.Dispose()
    }
}

function Invoke-Keytool {
    param([Parameter(Mandatory = $true)][string[]]$Arguments)

    $previousErrorActionPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = @(& $keytoolCommand.Source @Arguments 2>&1)
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    return [pscustomobject]@{
        Output = $output
        ExitCode = $exitCode
    }
}

if ($Resume) {
    $backupPassphrase = Read-BackupPassphrase
    $storedCredentials = ConvertFrom-EncryptedCredentialBackup `
        -Path $portableCredentialBackupPath `
        -Passphrase $backupPassphrase
    if ($storedCredentials.repository -ne $Repository) {
        throw "O backup pertence a $($storedCredentials.repository), não a $Repository."
    }
    if ($storedCredentials.signingProfile -ne $SigningProfile -or
        $storedCredentials.keystoreSecretName -ne $KeystoreSecretName -or
        $storedCredentials.storePasswordSecretName -ne $StorePasswordSecretName -or
        $storedCredentials.keyAliasSecretName -ne $KeyAliasSecretName -or
        $storedCredentials.keyPasswordSecretName -ne $KeyPasswordSecretName -or
        $storedCredentials.certificateSha256SecretName -ne $CertificateSha256SecretName) {
        throw 'O backup não corresponde ao perfil Stable Dev; nenhum secret foi enviado.'
    }
    if ([string]::IsNullOrWhiteSpace([string]$storedCredentials.keyAlias) -or
        [string]::IsNullOrWhiteSpace([string]$storedCredentials.storePassword) -or
        [string]::IsNullOrWhiteSpace([string]$storedCredentials.keyPassword) -or
        [string]::IsNullOrWhiteSpace([string]$storedCredentials.certificateSha256) -or
        [string]::IsNullOrWhiteSpace([string]$storedCredentials.keystoreSha256)) {
        throw 'O backup criptografado está incompleto; nenhum secret foi enviado.'
    }
    if ($storedCredentials.keyAlias -ne $KeyAlias) {
        throw 'O alias da chave no backup não corresponde ao perfil Stable Dev.'
    }

    New-Item -ItemType Directory -Path $signingDirectory -Force | Out-Null
    if (-not $hasKeystore) {
        [IO.File]::Copy($keystoreBackupPath, $keystorePath, $false)
    }
    $localKeystoreHash = (Get-FileHash -LiteralPath $keystorePath -Algorithm SHA256).Hash
    $backupKeystoreHash = (Get-FileHash -LiteralPath $keystoreBackupPath -Algorithm SHA256).Hash
    if ($localKeystoreHash -ne $backupKeystoreHash -or $localKeystoreHash -ne $storedCredentials.keystoreSha256) {
        throw 'A keystore não corresponde ao backup criptografado; nenhum secret foi enviado.'
    }

    $storePassword = [string]$storedCredentials.storePassword
    $keyPassword = [string]$storedCredentials.keyPassword
    $keyAlias = [string]$storedCredentials.keyAlias
    $fingerprint = [string]$storedCredentials.certificateSha256
    Set-Item -Path "Env:$storePasswordEnvironmentVariable" -Value $storePassword
    try {
        $localKeystoreHash = (Get-FileHash -LiteralPath $keystorePath -Algorithm SHA256).Hash
        $backupKeystoreHash = (Get-FileHash -LiteralPath $keystoreBackupPath -Algorithm SHA256).Hash
        if ($localKeystoreHash -ne $backupKeystoreHash) {
            throw 'A cópia segura da keystore não corresponde ao arquivo local; nenhum secret foi enviado.'
        }

        $keytoolListArguments = @(
            '-list', '-v',
            '-keystore', $keystorePath,
            '-storepass:env', $storePasswordEnvironmentVariable,
            '-alias', $keyAlias
        )
        $keytoolResult = Invoke-Keytool $keytoolListArguments
        if ($keytoolResult.ExitCode -ne 0) {
            throw 'keytool não conseguiu validar a keystore existente; nenhum secret foi enviado.'
        }
        $actualFingerprint = $null
        foreach ($line in $keytoolResult.Output) {
            if ([string]$line -match '^\s*SHA-?256:\s*(?<value>(?:[0-9A-Fa-f]{2}:?)+)\s*$') {
                $actualFingerprint = $Matches['value']
                break
            }
        }
        if ($actualFingerprint -ne $fingerprint) {
            throw 'O fingerprint da keystore não corresponde ao backup protegido; nenhum secret foi enviado.'
        }
    }
    finally {
        Remove-Item "Env:$storePasswordEnvironmentVariable" -ErrorAction SilentlyContinue
    }
}
else {
    New-Item -ItemType Directory -Path $signingDirectory -Force | Out-Null
    Write-Host "No Dashlane, crie o item 'Kazuji Dev signing backup' e guarde nele uma senha mestra aleatória de 24+ caracteres."
    $backupPassphrase = Read-BackupPassphrase -Confirm
    $storePassword = New-RandomPassword
    # PKCS12 uses the keystore password for private key entries.
    $keyPassword = $storePassword
    $credentialsSaved = $false
    $backupCopyCreated = $false
    $encryptedBackupCreated = $false
    try {
        Set-Item -Path "Env:$storePasswordEnvironmentVariable" -Value $storePassword
        Set-Item -Path "Env:$keyPasswordEnvironmentVariable" -Value $keyPassword
        $keytoolArguments = @(
            '-genkeypair',
            '-keystore', $keystorePath,
            '-storetype', 'PKCS12',
            '-alias', $keyAlias,
            '-keyalg', 'RSA',
            '-keysize', '3072',
            '-validity', '10000',
            '-dname', $DistinguishedName,
            '-storepass:env', $storePasswordEnvironmentVariable,
            '-keypass:env', $keyPasswordEnvironmentVariable,
            '-noprompt'
        )
        $keytoolResult = Invoke-Keytool $keytoolArguments
        if ($keytoolResult.ExitCode -ne 0) {
            $keytoolResult.Output | ForEach-Object { Write-Host $_ }
            throw "keytool falhou ao criar a keystore (código $($keytoolResult.ExitCode))."
        }

        $keytoolListArguments = @(
            '-list', '-v',
            '-keystore', $keystorePath,
            '-storepass:env', $storePasswordEnvironmentVariable,
            '-alias', $keyAlias
        )
        $keytoolResult = Invoke-Keytool $keytoolListArguments
        if ($keytoolResult.ExitCode -ne 0) {
            $keytoolResult.Output | ForEach-Object { Write-Host $_ }
            throw "keytool falhou ao verificar a keystore (código $($keytoolResult.ExitCode))."
        }
        $fingerprint = $null
        foreach ($line in $keytoolResult.Output) {
            if ([string]$line -match '^\s*SHA-?256:\s*(?<value>(?:[0-9A-Fa-f]{2}:?)+)\s*$') {
                $fingerprint = $Matches['value']
                break
            }
        }
        if ([string]::IsNullOrWhiteSpace($fingerprint)) {
            throw 'Não foi possível extrair o fingerprint SHA-256; nenhum secret será enviado.'
        }

        $keystoreHash = (Get-FileHash -LiteralPath $keystorePath -Algorithm SHA256).Hash
        $credentialBackup = [ordered]@{
            repository = $Repository
            signingProfile = $SigningProfile
            keystoreSecretName = $KeystoreSecretName
            storePasswordSecretName = $StorePasswordSecretName
            keyAliasSecretName = $KeyAliasSecretName
            keyPasswordSecretName = $KeyPasswordSecretName
            certificateSha256SecretName = $CertificateSha256SecretName
            keyAlias = $keyAlias
            certificateSha256 = $fingerprint
            keystoreSha256 = $keystoreHash
            storePassword = $storePassword
            keyPassword = $keyPassword
        }
        $credentialBackupJson = $credentialBackup | ConvertTo-Json -Depth 4 -Compress
        $encryptedBackupJson = ConvertTo-EncryptedCredentialBackup `
            -Passphrase $backupPassphrase `
            -Plaintext $credentialBackupJson
        New-Item -ItemType Directory -Path $backupDirectoryFull -Force | Out-Null
        $encryptedBackupBytes = [Text.Encoding]::UTF8.GetBytes($encryptedBackupJson)
        $encryptedBackupStream = [IO.File]::Open(
            $portableCredentialBackupPath,
            [IO.FileMode]::CreateNew,
            [IO.FileAccess]::Write,
            [IO.FileShare]::None
        )
        $encryptedBackupCreated = $true
        try {
            $encryptedBackupStream.Write($encryptedBackupBytes, 0, $encryptedBackupBytes.Length)
        }
        finally {
            $encryptedBackupStream.Dispose()
            [Array]::Clear($encryptedBackupBytes, 0, $encryptedBackupBytes.Length)
        }
        [IO.File]::Copy($keystorePath, $keystoreBackupPath, $false)
        $backupCopyCreated = $true
        $credentialsSaved = $true
        $credentialBackup = $null
        $credentialBackupJson = $null
        $encryptedBackupJson = $null
    }
    catch {
        if (-not $credentialsSaved) {
            Remove-Item -LiteralPath $keystorePath -Force -ErrorAction SilentlyContinue
            if ($backupCopyCreated) {
                Remove-Item -LiteralPath $keystoreBackupPath -Force -ErrorAction SilentlyContinue
            }
            if ($encryptedBackupCreated) {
                Remove-Item -LiteralPath $portableCredentialBackupPath -Force -ErrorAction SilentlyContinue
            }
        }
        throw
    }
    finally {
        Remove-Item "Env:$storePasswordEnvironmentVariable" -ErrorAction SilentlyContinue
        Remove-Item "Env:$keyPasswordEnvironmentVariable" -ErrorAction SilentlyContinue
    }
}

if (-not $Resume) {
    Write-Host "A keystore e sua cópia protegida por senha foram criadas."
    Write-Host 'Guarde a senha mestra no Dashlane e confirme a presença dos dois arquivos de backup.'
    $backupConfirmation = Read-Host 'Digite BACKUP para enviar os secrets'
    if ($backupConfirmation -cne 'BACKUP') {
        $storePassword = $null
        $keyPassword = $null
        $backupPassphrase = $null
        throw 'Upload cancelado. Os backups foram preservados; use -Resume depois de verificar o Dashlane.'
    }
}

try {
    $keystoreBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($keystorePath))
    # Send the keystore last so the workflow receives it after the other values.
    Set-GitHubSecretFromStdin -Name $StorePasswordSecretName -Value $storePassword
    Set-GitHubSecretFromStdin -Name $KeyAliasSecretName -Value $keyAlias
    Set-GitHubSecretFromStdin -Name $KeyPasswordSecretName -Value $keyPassword
    Set-GitHubSecretFromStdin -Name $CertificateSha256SecretName -Value $fingerprint
    Set-GitHubSecretFromStdin -Name $KeystoreSecretName -Value $keystoreBase64

    Write-Host "Stable Dev secrets uploaded to $Repository. Secret values were not printed."
    Write-Host "Local keystore: $keystorePath"
    Write-Host "Encrypted credential backup: $portableCredentialBackupPath"
    Write-Host "Keystore backup: $keystoreBackupPath"
    Write-Host "Certificate SHA-256 (public): $fingerprint"
}
catch {
    Write-Host 'A keystore e os backups foram preservados fora do repositório.'
    Write-Host 'Para reenviar os mesmos secrets, execute novamente com -Resume.'
    throw
}
finally {
    Remove-Item "Env:$storePasswordEnvironmentVariable" -ErrorAction SilentlyContinue
    Remove-Item "Env:$keyPasswordEnvironmentVariable" -ErrorAction SilentlyContinue
    $storePassword = $null
    $keyPassword = $null
    $backupPassphrase = $null
    $keystoreBase64 = $null
}
