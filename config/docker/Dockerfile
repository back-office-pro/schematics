FROM ruby:3.4.2-alpine

RUN apk add --update --no-cache \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-3.alpinelinux.org/alpine/edge/main vips-dev

RUN apk --update add --virtual \
    runtime-deps build-base libxml2-dev \
    libxslt-dev nodejs yarn libffi-dev readline \
    build-base sqlite-dev libc-dev linux-headers \
    readline-dev file git tzdata graphviz jemalloc pgloader ffmpeg bash \
    && rm -rf /var/cache/apk/*

ARG BUNDLE_GITHUB__COM

ENV MALLOC_ARENA_MAX=2
ENV RUBY_YJIT_ENABLE=1
ENV WEB_CONCURRENCY=auto
ENV RAILS_ENV=production
ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"

WORKDIR /app
COPY . /app

RUN BUNDLE_GITHUB__COM=$BUNDLE_GITHUB__COM bundle install --jobs=4 --retry=3

ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000
