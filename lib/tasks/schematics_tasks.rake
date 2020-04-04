namespace :schematics do
  desc "Generate schema application"
  task :generate do
    Schematics::SCHEMA.generate
  end

  namespace :db do
    desc "Load engine seed"
    task seed: :environment do
      Schematics::Engine.load_seed
    end
  end
end
