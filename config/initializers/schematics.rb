# frozen_string_literal: true

Rails.configuration.to_prepare do
  Schematics::Schema.instance.load(data: ::SchemaDataset.current.data)
rescue StandardError
  nil
end
