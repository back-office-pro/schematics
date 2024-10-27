# frozen_string_literal: true

require 'bootstrap-email'

BootstrapEmail.configure do |config|
  config.sass_email_string = <<~SCSS
    $primary: #2c3e50;
    @import 'bootstrap-email';
  SCSS
end
