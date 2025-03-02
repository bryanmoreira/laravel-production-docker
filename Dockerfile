# Usa a imagem oficial do PHP com suporte a FPM e extensões
FROM php:8.2-fpm

# Instala extensões necessárias do PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql opcache

# Define o diretório de trabalho
WORKDIR /var/www

# Copia os arquivos do Laravel para o container
COPY . .

# Baixa e instala o Composer dentro do container
RUN apt-get update && apt-get install -y curl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Instala dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Dá permissão para a pasta de cache e logs
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expõe a porta 9000 do PHP-FPM
EXPOSE 9000

RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 777 /var/www/storage /var/www/bootstrap/cache

CMD ["php-fpm"]
