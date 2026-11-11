# Validar fontes PT-BR — lote 1

Versão planejada do APK: 9.8.5-ptbr-lote1 (debug).
Não há aprovação no aparelho ainda. O link do APK, os SHAs e o resultado dos testes remotos
serão adicionados após a build. O APK contém a biblioteca fixada num commit, não atualiza sozinha.

## Fontes para procurar

| Ordem | Nome no Kazuji | Buscar/abrir | Conferir |
| --- | --- | --- | --- |
| 1 | BorutoExplorer | Naruto: Versão Colorida Oficial | 187 capítulos observados em 02/10, volumes, número187 e 20 imagens no capítulo187 |
| 2 | NinjaComics | Princípe Dragão Sagrado | 1305 capítulos/partes observados em 02/10, número652.5 preservado, status finalizado |
| 3 | CafecomYaoi | Amor Involuntário | Fonte já existente; teste de regressão, busca/capa/detalhes/capítulos/páginas |
| 4 | Nexus Mangás | One Piece | Fonte já existente; testar cancelamento/Feito no navegador e leitura após ação manual |

HuntersScan continua marcada como quebrada até comprovar o fluxo completo. Correções de cancelamento
e falha parcial não são suficientes para anunciar que está funcional.
Manga Night não entra como leitor: a ficha informa que não hospeda capítulos e só oferece links externos.

As contagens são observações do site naquela data, não um resultado já obtido pelo parser/aplicativo.
O site pode ganhar capítulos depois. NinjaComics exibiu anúncio intersticial na navegação ao capítulo;
registrar a barreira se aparecer no app. Não confirmar leitura quando ela continuar bloqueada.

## Checklist por fonte

- [ ] Localizar pelo nome e idioma Português nas fontes do Kazuji.
- [ ] Abrir catálogo, navegar uma página adicional quando disponível e conferir que não repete obras.
- [ ] Buscar a obra indicada; verificar título, URL pública e capa.
- [ ] Testar cada filtro e ordenação anunciados pela fonte, incluindo combinação e busca sem resultado.
- [ ] Abrir detalhes e comparar autores, aliases, sinopse, gêneros, status, avaliação e capa com o site.
- [ ] Conferir todos os capítulos e sua ordem: número real/decimal, volume, título e datas.
- [ ] Abrir capítulo antigo e recente; conferir quantidade, ordem, imagens e ausência de interface/ads.
- [ ] Adicionar aos favoritos, abrir de novo pelo histórico e confirmar posição de leitura.
- [ ] Baixar um capítulo, abrir offline e confirmar páginas; restaurar conexão para testar atualização.
- [ ] Testar tracking de capítulos novos; conferir que não duplica obra/capítulos ao atualizar.
- [ ] Se houver BrowserActivity, testar Voltar (cancelamento) e Feito após ação humana bem-sucedida.
- [ ] Registrar AdBlock ligado/desligado quando a fonte depende da WebView, sem mudar automaticamente.

## Resultado a registrar

Copiar para cada fonte:

```text
Fonte:
Versão do APK e SHA/identidade da build:
Aparelho e versão Android:
Data:
Obra/capítulo:
Catálogo / busca / filtros / detalhes / capítulos / páginas:
Download e atualização:
Barreira de navegador e AdBlock:
Resultado: Aprovado / Parcial / Quebrado
Evidência ou mensagem de erro:
```

Só mudar o estado PENDENTE depois da validação no Kazuji instalado. Build e testes fixture
aprovam respectivamente compilação e comportamento coberto, e não toda a fonte no aparelho.
