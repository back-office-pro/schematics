# frozen_string_literal: true

BootstrapEmail.configure do |config|
  config.sass_email_location = Schematics::Engine
                               .root
                               .join('app', 'assets', 'stylesheets', 'schematics', 'mailer.scss')
  config.sass_load_paths = [
    Rails.root.join('node_modules'),
    Schematics::Engine.root.join('app', 'assets', 'stylesheets', 'schematics')
  ]
end
