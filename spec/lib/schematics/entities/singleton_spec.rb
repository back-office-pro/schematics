# frozen_string_literal: true

describe Schematics::Entities::Singleton do
  subject(:entity) { described_class.new(name:, attributes:) }

  let(:name) { 'configuration' }
  let(:attributes) do
    [
      {
        name: 'company_name',
        type: 'string'
      }
    ]
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      include Schematics::Singleton
    RUBY
  end
end
