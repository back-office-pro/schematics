#!/bin/sh

set -e

bin/rails schematics:jobs:run &
rm -rf tmp/pids/server.pid

exec "$@"
