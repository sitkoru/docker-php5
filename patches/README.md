# Источник исправлений

Все три файла взяты без изменений из [Debian PHP Maintainers](https://salsa.debian.org/php-team/php/-/tree/37a17e9a4ea67d5422411675b8564860dcf4cc22/debian/patches), commit `37a17e9a4ea67d5422411675b8564860dcf4cc22`.

| Файл | SHA256 |
| --- | --- |
| 0261-Avoid-state-corruption-via-bailout.patch | d945982b5ab29bc5c42d1892750d72d39ae911df8b9f4f5ea47d133707ab72a4 |
| 0262-Fix-repeated-warning-for-file-uploads-limit-exceedin.patch | bbb0caf07682ec8815097049920ea04b3ca81f53e9066df8ee637c410427f658 |
| 0263-Introduce-max_multipart_body_parts-INI.patch | 2dbf19354960813482ef1bf6799d3f1aa02433a146825941917bdf6a1d414d90 |

0261 переносит [официальное EOL-исправление PHP7.4](https://github.com/php/php-src/commit/712e60f9edfd03f0960fc4fc3c2c375f42b90aa2) на PHP5.6. 0262 и 0263 добавляют связанный лимит multipart, описанный в заголовке 0261. Применимость проверена к официальному PHP5.6.40 без fuzz. Эти патчи не являются полным набором всех накопленных исправлений Debian для PHP5.6.
