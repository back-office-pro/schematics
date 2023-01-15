# frozen_string_literal: true

require 'i18n'

RSpec.configure do |config|
  config.before(:all) do
    I18n.load_path += Dir[
      File.expand_path('../../config/locales/defaults/*.yml', __dir__),
      File.expand_path('../../config/locales/models/schematics/**/*.yml', __dir__)
    ]
  end
end
