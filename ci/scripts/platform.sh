#!/usr/bin/env bash
cp .env.example .env
composer install

php artisan config:clear
php artisan key:generate
