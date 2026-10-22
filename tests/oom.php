<?php
register_shutdown_function(function () { echo "SHUTDOWN_RAN\n"; });
str_repeat("x", 16 * 1024 * 1024);
