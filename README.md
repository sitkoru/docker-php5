# docker-php5

Образы PHP 5.6.40 FPM (`fpm`) и среды разработки (`dev`) с прежним набором расширений.

Ядро пересобирается из официального архива PHP 5.6.40 с переносом исправлений CVE-2026-109618/CVE-2026-109619 от Debian PHP Maintainers. PHP API и версии расширений сохранены. Источник патчей: [Debian commit 37a17e9a](https://salsa.debian.org/php-team/php/-/tree/37a17e9a4ea67d5422411675b8564860dcf4cc22/debian/patches). Файлы `0261`, `0262`, `0263` сохранены без изменений; последние два добавляют связанный лимит multipart (CVE-2023-0662).

Перенос намеренно завершает процесс при нехватке памяти без пользовательских shutdown handlers и полностью отключает session upload progress. Обычные формы и загрузки файлов остаются доступными. `max_multipart_body_parts=-1` задаёт лимит как `max_input_vars + max_file_uploads`.

PHP 5.6 и Debian stretch остаются EOL. Эти исправления двух CVE не означают общую поддержку безопасности старой среды.

## Локальная проверка без публикации

```sh
docker buildx build --platform linux/amd64 --target fpm --load -t php5-check:fpm .
docker run --rm --network none --memory 256m -v "$PWD/tests:/checks:ro" php5-check:fpm sh /checks/smoke.sh
docker buildx build --platform linux/amd64 --target dev --load -t php5-check:dev .
docker run --rm --network none --memory 256m -e PHP_IMAGE_TARGET=dev -v "$PWD/tests:/checks:ro" php5-check:dev sh /checks/smoke.sh
docker buildx build --platform linux/amd64 --target verify .
docker buildx build --platform linux/amd64 --target regression .
```

`smoke.sh` запускает настоящее ядро, проверяет расширения, GD/intl, FPM-конфигурацию и завершение по OOM. `verify` отправляет настоящий локальный FastCGI-запрос без опубликованных портов. `regression` запускает четыре существующих upstream PHPT для multipart и сессий и собственный PHPT отключения upload progress с успешной загрузкой файла; временный CGI собирается только в проверочной стадии. В upstream EOL security commit нет отдельных PHPT этих двух CVE; выбранные проверки не выдаются за полный тест отсутствия уязвимостей. Они не обращаются к production, БД или Redis.

Dev сохраняет Xdebug 2.5.5 и использует совместимую линию Composer 2.2 LTS. APT использует подписанный архив Debian и закреплённый официальный keyring; проверка подписи пакетов не отключается.

Сборка ограничена двумя процессами компиляции.

Actions выполняют проверки на `linux/amd64`. Pull request, ветки задач и ручной запуск ничего не публикуют и не требуют входа в GHCR. Существующая публикация сохранена только для push в `master` и тегов `v*.*.*`, после проверок. Слияние и выпуск должны выполняться отдельно.

## Вариант nginx для существующих приложений

Цель `with-nginx` сохраняет интерфейс `ghcr.io/sitkoru/php:5.6-nginx`: порт 80, PHP-FPM 9000, `APP_BEFORE_START_SCRIPT`, `/etc/nginx/conf.d/site.conf`, `/etc/nginx/php_fastcgi.conf`, пользователь `www-data` (UID 33, home `/var/www`), `/usr/bin/msmtp`, а также `mysql`, `exif` и `gmp`. Приложение и его секреты не входят в этот репозиторий.

[Nginx 1.30.6 stable](https://nginx.org/en/download.html) собирается из официальных исходников с [OpenSSL 3.5.9 LTS](https://openssl-library.org/source/), связанным статически только с nginx. Исходные SHA256 закреплены в `nginx/build.sh`; PHP продолжает использовать прежний OpenSSL ABI. Сборка nginx не устанавливает новые системные SSL-библиотеки.

```sh
docker buildx build --platform linux/amd64 --target with-nginx --load -t php5-check:nginx .
```

Отдельный workflow `nginx.yml` выполняет только сборку и изолированный HTTP-запрос через nginx в PHP, проверку дополнительных модулей и безопасный фиктивный startup hook. Он никогда не публикует образы. Будущий выпуск должен отдельно опубликовать проверенный `with-nginx` под точным тегом `ghcr.io/sitkoru/php:5.6-nginx`; права записи пакета из этого репозитория пока не проверены. Само слияние изменений этого варианта не обновляет приложения.
