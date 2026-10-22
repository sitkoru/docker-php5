<?php
if (PHP_VERSION !== '5.6.40') { throw new Exception('Unexpected PHP version'); }
$required = array('bcmath', 'gd', 'intl', 'memcache', 'memcached', 'mysql', 'mysqli', 'pcntl', 'pdo_mysql', 'pdo_pgsql', 'pgsql', 'redis', 'soap', 'xsl', 'zip', 'Zend OPcache', 'curl', 'mbstring', 'openssl', 'session', 'PDO');
foreach ($required as $module) {
    if (!extension_loaded($module)) { throw new Exception('Missing extension: ' . $module); }
}
if (getenv('PHP_IMAGE_TARGET') === 'dev' && !extension_loaded('xdebug')) { throw new Exception('Missing xdebug'); }
$image = imagecreatetruecolor(2, 2);
if (!$image) { throw new Exception('GD failed'); }
imagedestroy($image);
if (normalizer_normalize("e\xCC\x81") !== "\xC3\xA9") { throw new Exception('Intl failed'); }
if (ini_get('max_multipart_body_parts') !== '-1') { throw new Exception('Missing multipart limit'); }
echo "runtime modules: OK\n";
