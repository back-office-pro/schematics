# frozen_string_literal: true

Sidekiq.default_configuration.merge! YAML.load_file(Schematics::Engine.join_config('sidekiq.yml'))
