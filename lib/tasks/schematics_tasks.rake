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
    desc 'Update application licence'
    task :update, [:plan, :term] => [:environment] do |task, args|
      Licence.instance.update(
        plan: args[:plan],
        expires_at: args[:term].to_i.months.from_now
      )
    end
  end

  namespace :db do
    desc 'Load engine seed'
    task seed: :environment do
      Schematics::Engine.load_seed
    end
  end

  desc 'Generate API request documentation from API specs'
  RSpec::Core::RakeTask.new('docs:generate') do |t|
    t.pattern = 'spec/acceptance/**/*_spec.rb'
    t.rspec_opts = [
      Gem::Specification.find_by_name('schematics').gem_dir,
      '--format RspecApiDocumentation::ApiFormatter',
      '--order defined'
    ]
  end
end
