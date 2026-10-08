# frozen_string_literal: true

BootstrapEmail.configure do |config|
  config.sass_email_string = lambda {
    <<~SCSS
      @use 'scss/variable' with (
        $primary: #{Configuration.theme_color}
      );
      @use 'bootstrap-email';
    SCSS
  }
end
