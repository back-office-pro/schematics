#!/bin/sh

set -e

bin/rails db:migrate
bin/rails schematics:db:seed
bin/rails searchkick:reindex:all

freshclam -d &
clamd &

rm -rf /app/spec/dummy/tmp/pids/server.pid

exec "$@"
