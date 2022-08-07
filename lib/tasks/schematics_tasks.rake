# frozen_string_literal: true

require 'active_record_doctor'
require 'active_record_doctor/rake/task'

namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Schematics::Schema
      .instance
      .entities
      .flat_map do |entity|
        [
          Schematics::Commands::CreateEntity.new(entity:),
          Schematics::Commands::CreateEntityCounterCaches.new(entity:),
          Schematics::Commands::CreateEntityPolymorphicCounterCaches.new(entity:)
        ]
      end
      .sort_by(&:weight)
      .flat_map(&:execute)
      .each(&method(:system))
  end

  namespace :permissions do
    desc 'Create entity permissions'
    task :create, %i[model] => [:environment] do |_task, model:|
      entity = model.constantize.entity
      Rails.application.reloader.reload!
      PaperTrail.request(enabled: false) do
        Role.admin.permissions.push(Permission.create_entity_permissions!(entity))
      end
    end

    desc 'Destroy entity permissions and associated models'
    task :destroy, %i[model] => [:environment] do |_task, model:|
      PaperTrail.request(enabled: false) do
        Permission.destroy_by(model:)
        Chart.destroy_by(model:)
        Stat.destroy_by(model:)
        Schematics::Version.destroy_by(item_type: model)
      end
    end

    desc 'Rename entity permissions and associated models'
    task :rename, %i[model new_model] => [:environment] do |_task, model:, new_model:|
      PaperTrail.request(enabled: false) do
        # rubocop:disable Rails/SkipsModelValidations
        Permission.where(model:).update_all(model: new_model)
        Chart.where(model:).update_all(model: new_model)
        Stat.where(model:).update_all(model: new_model)
        Schematics::Version.where(item_type: model).update_all(item_type: new_model)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end

  namespace :db do
    desc 'Load engine seed'
    task seed: :environment do
      Schematics::Engine.load_seed
    end

    ActiveRecordDoctor::Rake::Task.new do |task|
      task.deps = [:environment]
      task.config_path = Schematics::Engine.root.join('config', 'active_record_doctor.rb')
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
