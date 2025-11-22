#!/bin/sh
set -e

php artisan migrate --force || true
exec apache2-foreground
