# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.2.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 postgresql-client && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV MALLOC_ARENA_MAX=2
ENV RUBY_YJIT_ENABLE=1
ENV WEB_CONCURRENCY=auto
ENV RAILS_ENV=production
ENV LD_PRELOAD="/usr/local/lib/libjemalloc.so"

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config libpq-dev node-gyp python-is-python3 && \
    apt-get install --no-install-recommends -y graphviz pgloader ffmpeg file clamav clamav-daemon clamdscan chromium postfix && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ARG NODE_VERSION=23.9.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH

RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

COPY . .

RUN freshclam

RUN echo "FollowDirectorySymlinks true" >> /etc/clamav/clamd.conf
RUN echo "FollowFileSymlinks true" >> /etc/clamav/clamd.conf

RUN bundle install --jobs=4 --retry=3
RUN yarn install
RUN bundle exec bootsnap precompile -j 1 app/ lib/
RUN bin/rails assets:precompile
RUN bin/rails schematics:db:encryption:init
RUN bin/rails schematics:generate

ENTRYPOINT ["/app/bin/docker-entrypoint"]

CMD ["bin/rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000
