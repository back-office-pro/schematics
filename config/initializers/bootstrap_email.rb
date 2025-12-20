# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

BootstrapEmail.configure do |config|
  config.sass_email_string = lambda {
    <<~SCSS
      $primary: #{Configuration.theme_color};
      @import 'bootstrap-email';
    SCSS
  }
end
