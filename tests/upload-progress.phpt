--TEST--
Session upload progress remains disabled while file uploads work
--INI--
session.save_path=/tmp
session.upload_progress.enabled=1
session.upload_progress.cleanup=0
session.upload_progress.min_freq=0
session.upload_progress.freq=1
--COOKIE--
PHPSESSID=php5regression
--POST_RAW--
Content-Type: multipart/form-data; boundary=php5boundary
--php5boundary
Content-Disposition: form-data; name="PHP_SESSION_UPLOAD_PROGRESS"

check
--php5boundary
Content-Disposition: form-data; name="document"; filename="check.txt"
Content-Type: text/plain

hello
--php5boundary--
--FILE--
<?php
session_start();
var_dump(isset($_SESSION['upload_progress_check']));
var_dump($_FILES['document']['error']);
session_destroy();
?>
--EXPECT--
bool(false)
int(0)
