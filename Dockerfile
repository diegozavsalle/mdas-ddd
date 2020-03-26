FROM php:7.2-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www
# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    git \
    curl \
    apt-transport-https

RUN apt-get -y install \
    gcc \
    g++ \
    make \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ARG USER_ID

ENV USER_NAME=www \
    USER_GROUP=www \
    USER_ID="$USER_ID" \
    USER_GID=1000

# Add user for laravel application
RUN groupadd -g ${USER_GID} ${USER_GROUP}
RUN useradd -u ${USER_ID} -ms /bin/bash -g ${USER_NAME} ${USER_GROUP}


# Copy existing application directory permissions
COPY --chown=${USER_NAME}:${USER_GROUP} . /var/www

USER www
