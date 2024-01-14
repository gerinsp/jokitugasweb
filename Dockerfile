# Gunakan PHP 8.1 dengan Apache
FROM php:8.1-apache

# Install dependensi yang diperlukan
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        unzip \
    && docker-php-ext-install zip

# Setel direktori kerja di dalam container
WORKDIR /var/www/html

# Menyalin file sumber Laravel ke dalam container
COPY . /var/www/html

# Berikan izin yang sesuai untuk Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

# Generasi kunci aplikasi Laravel
RUN php artisan key:generate

# Konfigurasi Apache
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependensi PHP menggunakan Composer
RUN composer install

# Expose port 80
EXPOSE 80

# Jalankan Apache
CMD ["apache2-foreground"]
