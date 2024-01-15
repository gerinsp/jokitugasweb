# Gunakan PHP 8.1 dengan Apache
FROM php:8.1-apache

# Install dependensi yang diperlukan
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        unzip \
        libpq-dev \
        && docker-php-ext-install zip pdo_mysql pdo_pgsql

# Setel direktori kerja di dalam container
WORKDIR /var/www/html

# Menyalin file sumber Laravel ke dalam container
COPY . .

# Berikan izin yang sesuai untuk Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

# Jika file .env belum ada, salin dari .env.example
COPY .env.example .env

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependensi PHP menggunakan Composer
RUN composer install

# Generasi kunci aplikasi Laravel
RUN php artisan key:generate

# Expose port 8000 (port default untuk php artisan serve)
EXPOSE 8000

# Jalankan server pengembangan Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
