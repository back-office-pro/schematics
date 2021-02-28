namespace :schematics do
  desc 'Generate schema application'
  task generate: :environment do
    Schematics::SCHEMA.generate
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
    ]
  end
end
