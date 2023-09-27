# frozen_string_literal: true

Rails.configuration.to_prepare do
  require 'shoulda/callback/matchers'
  require 'shoulda/matchers'

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
