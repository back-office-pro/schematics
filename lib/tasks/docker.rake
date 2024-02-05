# frozen_string_literal: true

DOCKERFILE_PATH = Schematics::Engine.root.join('config', 'docker', 'Dockerfile').freeze
DOCKER_COMPOSE_PATH = Schematics::Engine.root.join('config', 'docker', 'docker-compose.yml').freeze
BUNDLE_GITHUB__COM = Schematics::Engine.credentials.github[:access_token].freeze

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
    task entrypoint: :environment do
      sleep 10 # wait for postgres to be ready
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      `bin/rails db:create`
      `bin/rails db:migrate`
      `bin/rails schematics:subscription:load`
      `bin/rails schematics:db:seed`
      `bin/rails schematics:credentials:backup`
    ensure
      `rm -rf tmp/pids/server.pid`
    end
  end
end
