# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.2.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV MALLOC_ARENA_MAX=2
ENV RUBY_YJIT_ENABLE=1
ENV WEB_CONCURRENCY=auto
ENV RAILS_ENV=on_premise

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config libpq-dev node-gyp python-is-python3 && \
    apt-get install --no-install-recommends -y graphviz pgloader ffmpeg file clamav clamav-daemon clamdscan chromium && \
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
RUN rails assets:precompile

RUN rm -rf /schematics/config/credentials/development*
RUN rm -rf /schematics/config/credentials/production*
RUN rm -rf /schematics/config/credentials/test*

RUN bin/schematics on-premise

ENTRYPOINT ["/app/bin/docker-entrypoint"]

CMD ["bin/rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000
