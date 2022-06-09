# frozen_string_literal: true

require 'active_record_doctor'
require 'active_record_doctor/rake/task'
require 'database_consistency'

namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Schematics::Schema
      .instance
      .sorted_entities
      .map { |entity| Schematics::Commands::CreateEntity.new(entity:) }
      .flat_map(&:execute)
      .each(&method(:system))
  end

  namespace :licence do
    desc 'Renew application licence'
    task :renew, %i[plan term] => [:environment] do |_task, args|
      PaperTrail.request(enabled: false) do
        Licence.instance.update!(plan: args[:plan], expires_on: args[:term].to_i.months.from_now)
      end
    end
  end

  namespace :permissions do
    desc 'Create entity permissions'
    task :create, %i[model] => [:environment] do |_task, args|
      entity = args[:model].constantize.entity
      Rails.application.reloader.reload!
      PaperTrail.request(enabled: false) do
        Role.admin.permissions.push(Permission.create_entity_permissions!(entity))
      end
    end

    desc 'Destroy entity permissions and associated models'
    task :destroy, %i[model] => [:environment] do |_task, args|
      PaperTrail.request(enabled: false) do
        Permission.destroy_by(model: args[:model])
        Chart.destroy_by(model: args[:model])
        Stat.destroy_by(model: args[:model])
        Schematics::Version.destroy_by(item_type: args[:model])
      end
    end

    desc 'Rename entity permissions and associated models'
    task :rename, %i[model new_model] => [:environment] do |_task, args|
      PaperTrail.request(enabled: false) do
        # rubocop:disable Rails/SkipsModelValidations
        Permission.where(model: args[:model]).update_all(model: args[:new_model])
        Chart.where(model: args[:model]).update_all(model: args[:new_model])
        Stat.where(model: args[:model]).update_all(model: args[:new_model])
        Schematics::Version.where(item_type: args[:model]).update_all(model: args[:new_model])
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end

  namespace :db do
    desc 'Load engine seed'
    task seed: :environment do
      Schematics::Engine.load_seed
    end

    desc 'Run database consistency checks'
    task consistency: :environment do
      Rails.application.eager_load!
      exit DatabaseConsistency
        .run(Schematics::Engine.root.join('config', 'database_consistency.yml'))
    end

    ActiveRecordDoctor::Rake::Task.new do |task|
      task.deps = [:environment]
      task.config_path = Schematics::Engine.root.join('config', 'active_record_doctor.rb')
      task.setup = -> { Rails.application.eager_load! }
    end

    namespace :encryption do
      desc 'Generate database encryption credentials'
      task init: :environment do
        sh %(EDITOR='echo "$(rails db:encryption:init | tail -n +2)" >> ' rails credentials:edit)
      end
    end
  end

  namespace :jobs do
    desc 'Start sidekiq with configuration'
    task run: :environment do
      sh "bin/bundle exec sidekiq -C #{Schematics::Engine.root.join('config', 'sidekiq.yml')}"
    end
  end

  namespace :docs do
    desc 'Generate OpenAPI docs'
    task generate: :environment do
      OpenApi.write_docs
    end
  end
end
