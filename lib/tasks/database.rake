# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_record_doctor'
require 'active_record_doctor/rake/task'

namespace :schematics do
  namespace :copy do
    desc 'Install engine migrations'
    task migrations: :environment do
      Core::Migrations::Copy.call
    end
  end

  namespace :db do
    desc 'Perform database backup'
    task backup: :environment do
      Core::Migrations::Backup.call(force: true)
    end

    desc 'Load engine seed'
    task seed: :environment do
      Schematics::Engine.load_seed
    end

    ActiveRecordDoctor::Rake::Task.new do |task|
      task.deps = [:environment]
      task.config_path = Schematics::Engine.root.join('config', 'active_record_doctor.rb')
      task.setup = -> { Rails.application.eager_load! }
    end

    namespace :migrate do
      desc 'Migrate database from sqlite3 to postgres'
      task postgres: :environment do
        db_path = Rails.root.join('storage', "#{Rails.env}_#{Tenant.database_name}.sqlite3")
        db_name = [Tenant.database_name, Rails.env].join('_')
        `createdb #{db_name}`
        `pgloader --with "preserve index names" sqlite://#{db_path} postgres://localhost/#{db_name}`
        `pumactl -P #{Rails.root.join("tmp/pids/#{Tenant.database_name}.pid")} restart`
      end
    end

    namespace :encryption do
      desc 'Generate database encryption credentials'	
      task init: :environment do	
        config = `rails db:encryption:init | tail -n +2`	
        credentials = Rails.application.credentials	
        credentials.write(credentials.read + config)	
      end
    end
  end
end
