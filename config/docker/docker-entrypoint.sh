#!/bin/sh

set -e

bin/rails db:create
bin/rails db:migrate
bin/rails schematics:licence:load
bin/rails schematics:db:seed
bin/rails searchkick:reindex:all
bin/bundle exec sidekiq &
rm -rf tmp/pids/server.pid

exec "$@"
