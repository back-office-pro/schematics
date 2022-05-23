# frozen_string_literal: true

if Rails.env.test?
  Rails.configuration.before_configuration do
    path = Schematics::Engine.root.join('spec', 'fixtures', 'schema_datasets.yml')
    Schematics::Schema.load(YAML.load_file(path).dig('one', 'data'))
  end
else
  Rails.configuration.to_prepare do
    Schematics::Schema.load(::SchemaDataset.current.data)
  rescue StandardError
    nil
  end
end
