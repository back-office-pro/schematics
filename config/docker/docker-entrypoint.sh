#!/bin/sh

set -e

bin/rails db:create
bin/rails db:migrate
bin/rails schematics:db:seed
bin/rails searchkick:reindex:all
bin/rails schematics:jobs:run &
rm -rf tmp/pids/server.pid

exec "$@"
