<?php
if (!extension_loaded('exif') || !extension_loaded('gmp') || !function_exists('mysql_connect')) {
    http_response_code(500);
    exit('Missing PHP compatibility module');
}
echo 'nginx:' . PHP_VERSION;
