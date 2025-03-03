# Usa a imagem oficial do PHP com extensões necessárias
FROM php:8.2-cli

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
    unzip \
    git \
    curl \
    php-mysql \
    && rm -rf /var/lib/apt/lists/*


# Instala o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define o diretório de trabalho
WORKDIR /var/www

# Copia os arquivos do Laravel para dentro do container
COPY . .

# Instala as dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Dá permissão para storage e cache
RUN chmod -R 777 storage bootstrap/cache

# Expõe a porta 8000 do Laravel
EXPOSE 8000

# Comando para rodar o Laravel com artisan
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
