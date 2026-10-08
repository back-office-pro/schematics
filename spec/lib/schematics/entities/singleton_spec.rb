# frozen_string_literal: true

describe Schematics::Entities::Singleton do
  subject(:entity) { described_class.new(schema:, name:, attributes:) }

  let(:schema) { Schematics::Schema.new }
  let(:name) { 'configuration' }
  let(:attributes) do
    [
      name: 'company_name',
      type: 'string'
    ]
  end

  its(:actions) { is_expected.to eq(%i[show update]) }

  its('model_elements.last') do
    is_expected.to eq <<~RUBY
      include Schematics::Singleton
    RUBY
  end
end
