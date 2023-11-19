#!/bin/sh

set -e

bin/rails db:create
bin/rails db:migrate
bin/rails schematics:licence:load
bin/rails schematics:db:seed
bin/rails schematics:credentials:backup
rm -rf tmp/pids/server.pid

exec "$@"
