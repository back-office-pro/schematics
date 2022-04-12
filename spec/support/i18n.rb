# frozen_string_literal: true

require 'i18n'

RSpec.configure do |config|
  config.before(:all) do
    I18n.load_path += Dir["config/locales/defaults/*.yml"]
  end
end
