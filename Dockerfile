FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl git nodejs \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# Install rbenv and Ruby
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && cd ~/.rbenv && src/configure && make -C src \
    && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> ~/.bashrc \
    && exec $SHELL \
    && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
    && rbenv install 2.7.2 \
    && rbenv global 2.7.2

# Set working directory
WORKDIR /srv/jekyll

# Copy the Gemfile and Gemfile.lock
COPY Gemfile* /srv/jekyll/

# Install gems
RUN bash -l -c "gem install bundler && bundle install --no-cache"

# Copy rest of the application code
COPY . /srv/jekyll

EXPOSE 8080

CMD ["bash", "-c", "exec jekyll serve"]
