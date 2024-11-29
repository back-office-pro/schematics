# frozen_string_literal: true

require 'bootstrap-email'

BootstrapEmail.configure do |config|
  config.sass_email_string = lambda {
    <<~SCSS
      $primary: #{Configuration.theme_color};
      @import 'bootstrap-email';
    SCSS
  }
end
