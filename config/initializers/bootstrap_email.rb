# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'bootstrap-email'

BootstrapEmail.configure do |config|
  config.sass_cache_location = BootstrapEmail::Config.new.sass_cache_location.join(Tenant.database_name) # rubocop:disable Layout/LineLength
  config.sass_email_string = lambda {
    <<~SCSS
      $primary: #{Configuration.theme_color};
      @import 'bootstrap-email';
    SCSS
  }
end
