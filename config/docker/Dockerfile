FROM ruby:3.2.2-alpine

RUN apk add --update --no-cache \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-3.alpinelinux.org/alpine/edge/main vips-dev

RUN apk --update add --virtual \
    runtime-deps postgresql-client build-base libxml2-dev \
    libxslt-dev nodejs yarn libffi-dev readline \
    build-base postgresql-dev sqlite-dev libc-dev linux-headers \
    readline-dev file git tzdata graphviz bash \
    && rm -rf /var/cache/apk/*

ARG BUNDLE_GITHUB__COM

RUN git config --global user.name "back-office"
RUN git config --global user.email "support@back-office.pro"
RUN git config --global init.defaultBranch "main"

WORKDIR /app
COPY . /app

RUN BUNDLE_GITHUB__COM=$BUNDLE_GITHUB__COM bundle install --jobs=4 --retry=3

ENTRYPOINT ["bin/rails", "schematics:docker:entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000
