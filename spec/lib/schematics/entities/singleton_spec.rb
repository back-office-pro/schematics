# frozen_string_literal: true

describe Schematics::Entities::Singleton do
  subject(:entity) { described_class.build(name:, attributes:) }

  let(:name) { 'setting' }
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
      acts_as_singleton
    RUBY
  end
end
