# frozen_string_literal: true

Rails.configuration.to_prepare do
  ::Tenant.current_schema = ::SchemaDataset.current_data
rescue NameError
  # do nothing
end
