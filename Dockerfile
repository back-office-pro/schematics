FROM ruby:3.0.0-alpine

RUN apk --update add --virtual \
    runtime-deps postgresql-client build-base libxml2-dev \
    libxslt-dev nodejs yarn libffi-dev readline \
    build-base postgresql-dev sqlite-dev libc-dev linux-headers \
    readline-dev file imagemagick git tzdata \
    && rm -rf /var/cache/apk/*

WORKDIR /app/spec/dummy
COPY . /app/

ENV BUNDLE_PATH /gems
RUN bundle install --jobs=4 --retry=3

ENTRYPOINT ["bin/rails"]
CMD ["s", "-b", "0.0.0.0"]

EXPOSE 3000
