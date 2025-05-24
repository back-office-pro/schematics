# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: false

Rails.configuration.to_prepare do
  Rails.configuration.secret_key_base = Rails.application.credentials.secret_key_base || Schematics::Engine.credentials.secret_key_base # rubocop:disable Layout/LineLength
  Rails.configuration.active_storage.service_configurations = Schematics::Engine.config_for(:storage) # rubocop:disable Layout/LineLength
  Rails.configuration.paths['config/environments'].unshift Schematics::Engine.root.join('config', 'environments') # rubocop:disable Layout/LineLength
  Rails.configuration.paths['config/database'].unshift Schematics::Engine.root.join('config', 'database.yml') # rubocop:disable Layout/LineLength
  Rails.configuration.paths['config/cable'].unshift Schematics::Engine.root.join('config', 'cable.yml') # rubocop:disable Layout/LineLength
  Rails.configuration.paths['config'].unshift Schematics::Engine.root.join('config')
end

if Rails.env.on_premise?
  Rails.configuration.after_initialize do
    suppress(StandardError) do
      Configuration.instance.update_storage_services!
    end
  end
end
