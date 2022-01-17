# frozen_string_literal: true

require 'bootstrap-email'

BootstrapEmail.configure do |config|
  config.sass_email_location = Schematics::Engine.root.join(
    'app',
    'assets',
    'stylesheets',
    'bootstrap-email',
    'mailer.scss'
  )
  config.sass_load_paths = [
    Rails.root.join('node_modules'),
    Schematics::Engine.root.join('app', 'assets', 'stylesheets', 'schematics')
  ]
end
