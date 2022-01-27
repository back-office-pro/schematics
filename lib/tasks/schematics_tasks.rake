# frozen_string_literal: true

namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Schematics::Schema
      .instance
      .sorted_entities
      .flat_map(&Schematics::System.method(:generate))
      .each(&method(:system))
  end

  desc 'Migrate schema application'
  task migrate: :environment do
    Schematics::Schema
      .instance
      .migrations
      .reject(&:migrated?)
      .flat_map(&:run)
      .each(&method(:system))
  end

  namespace :licence do
    desc 'Renew application licence'
    task :renew, %i[plan term] => [:environment] do |_task, args|
      PaperTrail.request(enabled: false) do
        Licence.instance.update!(plan: args[:plan], expires_at: args[:term].to_i.months.from_now)
      end
    end
  end

  namespace :users do
    desc 'Create admin user'
    task :admin, %i[email last_name first_name locale time_zone] => [:environment] do |_task, args|
      PaperTrail.request(enabled: false) do
        User.create!(args.to_h.merge(password: 'Azerty1!', role: Role.find_by(name: 'Admin')))
      end
    end
  end

  namespace :db do
    desc 'Load engine seed'
    task seed: :environment do
      Schematics::Engine.load_seed
    end
  end

  namespace :jobs do
    desc 'Start sidekiq with configuration'
    task run: :environment do
      sh "bin/bundle exec sidekiq -C #{Schematics::Engine.root.join('config', 'sidekiq.yml')}"
    end
  end

  namespace :docs do
    task generate: :environment do
      OpenApi.write_docs
    end
  end

  namespace :active_record do
    desc 'Run all active_record_doctor detectors'
    task doctor: :environment do
      Rails.application.eager_load!
      ActiveRecordDoctor::Runner
        .new(ActiveRecordDoctor.current_config)
        .run_all or exit(1)
    end
  end
end
