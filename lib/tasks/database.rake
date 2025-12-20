# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_record_doctor'
require 'active_record_doctor/rake/task'

namespace :schematics do
  namespace :db do
    desc 'Perform database backup'
    task backup: :environment do
      Schematics::GenerateBackupJob.perform_now ENV.fetch('DATABASE')
    end

    ActiveRecordDoctor::Rake::Task.new do |task|
      task.deps = [:environment]
      task.config_path = Rails.root.join('config/active_record_doctor.rb')
      task.setup = -> { Rails.application.eager_load! }
    end

    namespace :migrate do
      desc 'Migrate database from sqlite3 to postgres'
      task postgres: :environment do
        database_name = ENV.fetch('DATABASE')
        db_path = Rails.root.join('storage', database_name, "#{Rails.env}.sqlite3")
        db_name = [database_name, Rails.env].join('_')
        `createdb #{db_name}`
        `pgloader --with "preserve index names" sqlite://#{db_path} postgres://localhost/#{db_name}`
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
