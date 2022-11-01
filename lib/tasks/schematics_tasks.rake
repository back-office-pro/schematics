# frozen_string_literal: true

require 'active_record_doctor'
require 'active_record_doctor/rake/task'

namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Rails.application.load_generators
    Schematics::Migrations::CoreMigration
      .new(Schematics::Schema.instance)
      .build_commands
      .flat_map(&:generators)
      .each(&:invoke_all)
  end

  namespace :db do
    desc 'Perform database backup'
    task backup: :environment do
      Schematics::SchemaDatasets::Backup.call(force: true)
    end

    desc 'Load engine seed'
    task seed: :environment do
      Schematics::Engine.load_seed
    end

    ActiveRecordDoctor::Rake::Task.new do |task|
      task.deps = [:environment]
      task.config_path = Schematics::Engine.join_config('active_record_doctor.rb')
      task.setup = -> { Rails.application.eager_load! }
    end

    namespace :encryption do
      desc 'Generate database encryption credentials'
      task init: :environment do
        sh %[EDITOR='echo "$(rails db:encryption:init | tail -n +2)" >> ' rails credentials:edit]
      end
    end
  end

  namespace :jobs do
    desc 'Start sidekiq with configuration'
    task run: :environment do
      sh <<~SHELL
        bin/bundle exec sidekiq -C #{Schematics::Engine.join_config('sidekiq.yml')} -e #{Schematics::Engine.app_env}
      SHELL
    end
  end

  namespace :docs do
    desc 'Generate OpenAPI docs'
    task generate: :environment do
      Schematics::SchemaDatasets::WriteDocs.call
    end
  end

  namespace :licence do
    desc 'Load licence from gateway'
    task load: :environment do
      Licence.instance.load!
    end
  end
end
