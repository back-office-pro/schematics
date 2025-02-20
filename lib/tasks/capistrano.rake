# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

namespace :schematics do
  namespace :cap do
    desc 'Deploy application with capistrano'
    task deploy: :environment do
      `cap production deploy --rakefile #{Schematics::Engine.root.join('Capfile')}`
    end
  end
end
