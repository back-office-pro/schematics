# frozen_string_literal: true

Rails.configuration.to_prepare do
  Fx.configure do |config|
    config.dump_functions_at_beginning_of_schema = true
  end
end
