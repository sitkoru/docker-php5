#!/bin/sh
set -eu
cd /usr/src/php
export TEST_PHP_EXECUTABLE=/usr/local/bin/php
export TEST_PHP_CGI_EXECUTABLE=/usr/src/php/sapi/cgi/php-cgi
export REPORT_EXIT_STATUS=1 NO_INTERACTION=1
status=0
php run-tests.php -q \
    tests/basic/rfc1867_boundary_1.phpt tests/basic/rfc1867_boundary_2.phpt \
    tests/basic/rfc1867_array_upload.phpt ext/session/tests/001.phpt \
    /checks/upload-progress.phpt > /tmp/phpt.log 2>&1 || status=$?
cat /tmp/phpt.log
[ "$status" -eq 0 ]
grep -Eq 'Number of tests :[[:space:]]+5' /tmp/phpt.log
grep -Eq 'Tests skipped[[:space:]]*:[[:space:]]+0' /tmp/phpt.log
