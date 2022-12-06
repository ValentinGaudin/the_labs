FROM thecodingmachine/php:8.1-v4-apache

COPY --chown=docker:docker . .

ENV PHP_EXTENSIONS="gd zip"

ENV PHP_INI_UPLOAD_MAX_FILESIZE=200M
ENV PHP_INI_POST_MAX_SIZE=500M
ENV PHP_INI_MAX_EXECUTION_TIME=1000

RUN sudo chown -R docker:docker /etc/timezone
RUN sudo echo "Europe/Paris" > /etc/timezone

RUN composer install
