# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

DOCKERFILE_PATH = Schematics::Engine.root.join('config', 'docker', 'Dockerfile').freeze
DOCKER_COMPOSE_PATH = Schematics::Engine.root.join('config', 'docker', 'docker-compose.yml').freeze
BUNDLE_GITHUB__COM = Schematics::Engine.credentials.github.access_token.freeze

def run(command, *args)
  system(
    ["DOCKERFILE_PATH=#{DOCKERFILE_PATH}", 'docker-compose', '-f', DOCKER_COMPOSE_PATH, command]
      .concat(args)
      .join(' ')
  )
end

namespace :schematics do
  namespace :docker do
    desc 'Build docker image'
    task build: :environment do
      run :build, "--build-arg BUNDLE_GITHUB__COM=#{BUNDLE_GITHUB__COM}"
    end

    desc 'Re-build docker image'
    task rebuild: :environment do
      run :build, "--build-arg BUNDLE_GITHUB__COM=#{BUNDLE_GITHUB__COM} --no-cache"
    end

    desc 'Build & up docker image'
    task up: :environment do
      run :up, '-d'
    end

    desc 'Docker entrypoint'
    task :entrypoint do # rubocop:disable Rails/RakeEnvironment
      puts 'Creating database...'
      `bin/rails db:create`
      puts 'Migrating database...'
      `bin/rails db:migrate`
      puts 'Preparing database...'
      `bin/rails db:prepare`
      puts 'Loading subscription...'
      `bin/rails schematics:subscription:load`
      puts 'Seeding database...'
      `bin/rails schematics:db:seed`
      puts 'Credentials backup...'
      `bin/rails schematics:credentials:backup`
      puts 'Removing pid file...'
      `rm -rf tmp/pids/server.pid`
    end
  end
end
