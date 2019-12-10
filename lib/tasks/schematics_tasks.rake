namespace :schematics do
  desc "Generate schema application"
  task :generate do
    Schematics::SCHEMA.generate
  end
end
