#!/bin/sh

set -e

bin/rails schematics:jobs:run &
freshclam -d &
clamd &

rm -rf tmp/pids/server.pid

exec "$@"
