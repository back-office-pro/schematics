# frozen_string_literal: true

require 'active_record_doctor'
require 'active_record_doctor/rake/task'

namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Rails.application.load_generators
    Schematics::Migrations::CoreMigration
      .new(::Tenant.schema)
      .build_commands
      .flat_map(&:generators)
      .each(&:invoke_all)
  end

  namespace :nginx do
    desc 'Deploy nginx subdomain'
    task deploy: :environment do
      FileUtils.cp(Rails.root.join('config/nginx.conf'), Tenant.nginx_sites_available_path)
      FileUtils.ln_s(Tenant.nginx_sites_available_path, Tenant.nginx_sites_enabled_path)
      sh 'service nginx reload'
    end
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

    namespace :test do
      desc 'Prepare test database by loading current schema data'
      task prepare: :environment do
        data = SchemaDataset.current_data
        ActiveRecord::Base.establish_connection(:test)
        PaperTrail.request(enabled: false) do
          SchemaDataset.create!(state: :migrated, data:)
        end
      end
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
