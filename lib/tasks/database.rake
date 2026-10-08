# frozen_string_literal: true

namespace :schematics do
  namespace :db do
    desc 'Perform database backup'
    task backup: :environment do
      Schematics::GenerateBackupJob.perform_now
    end

    desc 'Dump current migration data'
    task dump: :environment do
      Core::Migrations::GenerateFixture.call
    end

    if Rails.env.development?
      ActiveRecordDoctor::Rake::Task.new do |task|
        task.deps = [:environment]
        task.config_path = Rails.root.join('config/active_record_doctor.rb')
        task.setup = -> { Rails.application.eager_load! }
      end
    end

    namespace :encryption do
      desc 'Generate database encryption credentials'
      task init: :environment do
        config = `rails db:encryption:init | tail -n +2`
        credentials = Rails.application.credentials
        credentials.write(credentials.read + config) unless credentials.active_record_encryption
      end
    end
  end
end
