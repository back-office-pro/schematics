# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.2.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /back-office

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 postgresql-client && \
    apt-get install --no-install-recommends -y graphviz pgloader ffmpeg file clamav clamav-daemon clamdscan chromium mailutils && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN freshclam

RUN echo "FollowDirectorySymlinks true" >> /etc/clamav/clamd.conf
RUN echo "FollowFileSymlinks true" >> /etc/clamav/clamd.conf

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so" \
    WEB_CONCURRENCY="auto" \
    MALLOC_ARENA_MAX="2" \
    RUBY_YJIT_ENABLE="1"

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config libpq-dev node-gyp python-is-python3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ARG NODE_VERSION=24.2.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

COPY Gemfile Gemfile.lock vendor ./

RUN bundle install --jobs=4 --retry=3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile -j 1 --gemfile

COPY package.json yarn.lock ./
RUN yarn install --immutable --immutable-cache --check-cache --production

COPY . .

RUN bundle exec bootsnap precompile -j 1 app/ lib/

RUN SECRET_KEY_BASE_DUMMY=1 bin/rails schematics:secret_key_base
RUN bin/rails assets:precompile
RUN bin/rails schematics:db:encryption:init
RUN bin/rails schematics:generate

RUN rm -rf app/assets/images
RUN rm -rf app/assets/stylesheets/custom
RUN rm -rf app/assets/stylesheets/themes
RUN rm -rf app/javascript
RUN rm -rf app/components/schematics/**/component.css
RUN rm -rf node_modules package.json yarn.lock vendor cache

FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /back-office /back-office

ENTRYPOINT ["/back-office/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/puma", "-C", "config/puma.rb", "--silent"]
