# Using a specific Ruby image for better compatibility with gems
FROM ruby:2.7

# Setting noninteractive environment to avoid prompts during build
ENV DEBIAN_FRONTEND noninteractive

# Setting up labels for metadata
LABEL MAINTAINER="Amir Pourmand"

# Update and install necessary packages for building native extensions
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    locales \
    imagemagick \
    build-essential \
    zlib1g-dev \
    libv8-dev \
    libgmp-dev \
    jupyter-nbconvert \
    inotify-tools \
    procps && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Setting locale environment variables
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production

# Prepare app directory
RUN mkdir /srv/jekyll
WORKDIR /srv/jekyll

# Adding Gemfile and Gemfile.lock
ADD Gemfile Gemfile.lock /srv/jekyll/

# Install a specific version of Bundler and run bundle install
RUN gem install bundler -v 2.4.22 && \
    bundle _2.4.22_ config --global silence_root_warning 1 && \
    bundle _2.4.22_ install --no-cache --verbose

# Expose port 8080 for service
EXPOSE 8080

# Copying entrypoint script
COPY bin/entry_point.sh /tmp/entry_point.sh

# Setting entrypoint and command
CMD ["/tmp/entry_point.sh"]
