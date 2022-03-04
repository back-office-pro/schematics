FROM ruby:3.1.1-alpine

RUN apk --update add --virtual \
    runtime-deps postgresql-client build-base libxml2-dev \
    libxslt-dev nodejs yarn libffi-dev readline \
    build-base postgresql-dev sqlite-dev libc-dev linux-headers \
    readline-dev file imagemagick git tzdata graphviz clamav clamav-libunrar \
    && rm -rf /var/cache/apk/*

WORKDIR /app/spec/dummy
COPY . /app/

ENV BUNDLE_PATH /gems
RUN bundle install --jobs=4 --retry=3

RUN echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    echo "TCPAddr 127.0.0.1" >> /etc/clamav/clamd.conf && \
    echo "Foreground yes" >> /etc/clamav/clamd.conf && \
    echo "Foreground yes" >> /etc/clamav/freshclam.conf && \
    mkdir /run/clamav && chown clamav:clamav /run/clamav

ENTRYPOINT ["/app/docker/docker-entrypoint.sh"]
CMD ["bin/rails", "s", "-b", "0.0.0.0"]

EXPOSE 3000
