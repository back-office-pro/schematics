# frozen_string_literal: true

require 'active_record_doctor'
require 'active_record_doctor/rake/task'

namespace :schematics do
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
end
