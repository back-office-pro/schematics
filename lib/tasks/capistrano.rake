# frozen_string_literal: true

namespace :schematics do
  namespace :cap do
    desc 'Deploy application with capistrano'
    task deploy: :environment do
      sh "cap production deploy --rakefile #{Schematics::Engine.root.join('Capfile')}"
    end
  end
end
