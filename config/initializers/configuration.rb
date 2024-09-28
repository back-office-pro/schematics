# frozen_string_literal: false

Rails.configuration.to_prepare do
  Rails.configuration.active_storage.service_configurations = Schematics::Engine.config_for(:storage) # rubocop:disable Layout/LineLength
  Rails.configuration.paths['config/environments'].unshift Schematics::Engine.root.join('config', 'environments') # rubocop:disable Layout/LineLength
  Rails.configuration.paths['config/database'].unshift Schematics::Engine.root.join('config', 'database.yml') # rubocop:disable Layout/LineLength
  Rails.configuration.paths['config/cable'].unshift Schematics::Engine.root.join('config', 'cable.yml') # rubocop:disable Layout/LineLength
  Rails.configuration.paths['config'].unshift Schematics::Engine.root.join('config')
end
