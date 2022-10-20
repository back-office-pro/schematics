FROM ruby:3.1.2-alpine

RUN apk --update add --virtual \
    runtime-deps postgresql-client build-base libxml2-dev \
    libxslt-dev nodejs yarn libffi-dev readline \
    build-base postgresql-dev sqlite-dev libc-dev linux-headers \
    readline-dev file git tzdata graphviz clamav clamav-daemon bash \
    && rm -rf /var/cache/apk/*

ARG APP_NAME

RUN git config --global user.name "back-office"
RUN git config --global user.email "support@back-office.pro"
RUN git config --global init.defaultBranch "main"

WORKDIR /app
COPY . /app

RUN bundle install --jobs=4 --retry=3
RUN bin/deploy

WORKDIR /home
RUN schematics $APP_NAME

WORKDIR /home/$APP_NAME

ENTRYPOINT ["/app/config/docker/docker-entrypoint.sh"]
CMD ["bin/rails", "s", "-b", "0.0.0.0"]

EXPOSE 3000
