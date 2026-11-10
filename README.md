<div align="center">

<img src="./kazuji.png" alt="Kazuji icon" width="160"/>

**Kazuji is a free and open-source manga reader for Android with built-in online content sources.**

![Android 6.0](https://img.shields.io/badge/android-6.0+-brightgreen) [![Sources count](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2FKotatsu-Redo%2Fkotatsu-parsers-redo%2Frefs%2Fheads%2Fmaster%2F.github%2Fsummary.yaml&query=total&label=manga%20sources&color=%23E9321C)](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo) [![License](https://img.shields.io/github/license/joaovpimenta/Kazuji)](https://github.com/joaovpimenta/Kazuji/blob/devel/LICENSE) [![GitHub Release](https://img.shields.io/github/v/release/joaovpimenta/Kazuji?sort=date&display_name=tag&style=flat)](https://github.com/joaovpimenta/Kazuji/releases/latest) [![IzzyOnDroid Yearly Downloads](https://img.shields.io/badge/dynamic/json?url=https://dlstats.izzyondroid.org/iod-stats-collector/stats/basic/yearly/rolling.json&query=$.['io.github.kazuji']&label=IzzyOnDroid%20yearly%20downloads)](https://apt.izzysoft.de/packages/io.github.kazuji) [![F-Droid Version](https://img.shields.io/badge/F--Droid-%2311AB00.svg?logo=f-droid&logoColor=white)](https://f-droid.org/en/packages/io.github.kazuji/) [![Discord](https://img.shields.io/discord/1452862077134700628)
](https://discord.gg/9sqBHXhwzz)


### Main Features

<div align="left">

* Online [manga catalogues](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo) (with 1200+ manga sources)
* Support for [Tachiyomi keiyoushi](https://github.com/keiyoushi/extensions) extensions
* Search manga by name, genres and more filters
* Favorites organized by user-defined categories
* Reading history, bookmarks and incognito mode support
* Download manga and read it offline. Third-party CBZ archives are also supported
* Clean and convenient Material You UI, optimized for phones, tablets and desktop
* Standard and Webtoon-optimized customizable reader, gesture support on reading interface
* Notifications about new chapters with updates feed, manga recommendations (with filters)
* Integration with manga tracking services: Shikimori, AniList, MyAnimeList, Kitsu
* Password / fingerprint-protected access to the app
* Automatically sync app data with other devices on the same account
* Support for older devices running Android 6.0+

</div>
<div align="left">

## Development Setup

### Prerequisites

- **JDK 17** (recommended: [Temurin](https://adoptium.net/temurin/releases/) distribution)
- **Android SDK** (compile SDK 36, build tools 35.0.0, minimum SDK 23)
- **Android Studio** (recommended) or Android SDK command-line tools

### Building the Project

1. **Clone the repository:**
   ```bash
   git clone https://github.com/joaovpimenta/Kazuji.git
   cd Kazuji
   ```

2. **Build debug APK:**
   ```bash
   ./gradlew assembleDebug
   ```
   Output: `app/build/outputs/apk/debug/app-debug.apk`

3. **Build release APK:**
   ```bash
   ./gradlew assembleRelease
   ```
   Output: `app/build/outputs/apk/release/app-release.apk`
   
   *Note: Requires keystore setup via environment variables or `local.properties`*

4. **Build nightly APK:**
   ```bash
   ./gradlew assembleNightly
   ```
   Output: `app/build/outputs/apk/nightly/app-nightly.apk`

### APK signing and compatible updates

- **Production release:** `io.github.kazuji`, signed with the original release keystore. Always use the same signing certificate and a `versionCode` greater than the installed version.
- **Signed Upgrade Test:** use the `Signed Upgrade Test` GitHub Actions workflow on the trusted `main` branch. It builds a release-variant APK with the **production application ID**, signs it using the existing release secrets, checks its certificate against the published `v9.8.5` APK, and uploads `kazuji-signed-upgrade-apk` as an artifact. It is a test artifact, not a stable release.
- **PR Debug Build:** `io.github.kazuji.debug` uses the CI runner's debug signing key. It is a separate app, cannot upgrade production, and its signature may differ across runners/builds. Do not rely on PR debug APKs to preserve existing debug app data.
- **Nightly:** `io.github.kazuji.nightly` also installs separately, even though it uses the release signing keystore.

**Preserved data after uninstall:** Android can retain signing metadata when uninstalling with data kept. If a new APK reports a signature conflict, first reinstall an APK from the same original distribution/signing key and export a backup from within the app. Do **not** erase kept data unless you accept losing it. GitHub release signing may differ from a separately distributed build (for example, an F-Droid-signed APK).

### Running Tests

- **Unit tests:**
  ```bash
  ./gradlew test
  ```

- **Instrumented tests:**
  ```bash
  ./gradlew connectedDebugAndroidTest
  ```

### Code Quality

- **Lint check:**
  ```bash
  ./gradlew lint
  ```

- **Full check (lint + tests):**
  ```bash
  ./gradlew check
  ```

For detailed contribution guidelines, see [CONTRIBUTING.md](./CONTRIBUTING.md).

Kazuji uses Android package `io.github.kazuji`. Android treats it as a separate app from Futon; export a backup from Futon and import it into Kazuji to move app data.

Kazuji accepts `kazuji://` links as well as legacy `futon://` and `kotatsu://` links.
</div>
### In-App Screenshots

<div align="center">
    <img src="./metadata/en-US/images/phoneScreenshots/1.png" alt="Mobile view" width="250"/>
    <img src="./metadata/en-US/images/phoneScreenshots/2.png" alt="Mobile view" width="250"/>
    <img src="./metadata/en-US/images/phoneScreenshots/3.png" alt="Mobile view" width="250"/>
    <img src="./metadata/en-US/images/phoneScreenshots/4.png" alt="Mobile view" width="250"/>
    <img src="./metadata/en-US/images/phoneScreenshots/5.png" alt="Mobile view" width="250"/>
    <img src="./metadata/en-US/images/phoneScreenshots/6.png" alt="Mobile view" width="250"/>
</div>

<br>

<div align="center">
    <img src="./metadata/en-US/images/tenInchScreenshots/1.png" alt="Tablet view" width="400"/>
    <img src="./metadata/en-US/images/tenInchScreenshots/2.png" alt="Tablet view" width="400"/>
</div>

### Downloads

[<img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroidButtonGreyBorder_nofont.png" height="80" alt="Get it at IzzyOnDroid">](https://apt.izzysoft.de/packages/io.github.kazuji)
[<img src="https://f-droid.org/badge/get-it-on.png"
    alt="Get it on F-Droid"
    height="80">](https://f-droid.org/packages/io.github.kazuji)

### Localization
Kazuji currently carries forward the [Futon Weblate translation project](https://hosted.weblate.org/engage/futon/).

<a href="https://hosted.weblate.org/engage/futon/"><img src="https://hosted.weblate.org/widget/futon/open-graph.png" width="500"></a>
<a href="https://hosted.weblate.org/engage/futon/"><img src="https://hosted.weblate.org/widget/futon/horizontal-auto.svg" width="500"></a>

### Contributing

<br>

**📌 Pull requests are welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.**

### Community

Join our Discord for support, discussion, and announcements: https://discord.gg/9sqBHXhwzz

### Certificate fingerprints

```plaintext
EF:48:B2:2E:F2:C5:40:45:53:1F:6E:76:00:C2:7E:C3:D0:3B:71:22:1E:0B:05:FF:B6:8E:33:57:CF:8E:4D:40
```

### License

[![GNU GPLv3 Image](https://www.gnu.org/graphics/gplv3-127x51.png)](http://www.gnu.org/licenses/gpl-3.0.en.html)

<div align="left">

You may copy, distribute and modify the software as long as you track changes/dates in source files. Any modifications
to or software including (via compiler) GPL-licensed code must also be made available under the GPL along with build &
install instructions.

</div>

### DMCA disclaimer

<div align="left">

The developers of this application do not have any affiliation with the content available in the app and does not store
or distribute any content. This application should be considered a web browser, all content that can be found using this
application is freely available on the Internet. All DMCA takedown requests should be sent to the owners of the website
where the content is hosted.

</div>

---

### Acknowledgments

<div align="left">

**Kazuji is a fork of [Futon](https://github.com/AppFuton/Futon), which is itself a fork of [Kotatsu](https://github.com/KotatsuApp/Kotatsu).**

We are deeply grateful to:

* **The original Kotatsu developers** for creating such an outstanding manga reader and making it open source
* **The Futon developers** for maintaining the fork that serves as Kazuji's immediate foundation
* **The Kotatsu community** for their contributions, testing, and support
* **All translators** who localized Kotatsu and Futon through Weblate
* **[Kotatsu-Redo](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo)** for continuing parser development and maintenance
* **[Kototoro](https://github.com/Kototoro-app/Kototoro)** for the Tachiyomi extension integration guide

Kazuji continues the work of both upstream projects and preserves their attribution. The Kotatsu team's dedication created the foundation that Futon extended and Kazuji continues.

**Thank you to everyone who contributed to Kotatsu — your work continues to benefit the manga reading community!**

For the original Kotatsu project, please visit: [github.com/KotatsuApp/Kotatsu](https://github.com/KotatsuApp/Kotatsu)

</div>
