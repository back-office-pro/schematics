# frozen_string_literal: true

namespace :schematics do
  desc 'Run rspec'
  task rspec: :environment do
    system(
      "bundle exec rspec --default-path #{Schematics::Engine.root.join('lib', 'spec')} -P '*.rb'",
      out: $stdout
    )
  end
end
