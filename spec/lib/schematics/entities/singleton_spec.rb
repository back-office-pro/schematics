# frozen_string_literal: true

describe Schematics::Entities::Singleton do
  subject(:entity) do
    described_class.create(name: name, attributes: attributes)
  end

  let(:name) { 'setting' }
  let(:attributes) do
    [
      {
        name: 'company_name',
        type: 'string'
      }
    ]
  end

  its(:route) do
    is_expected.to eq <<~RUBY
      resource :settings, only: [:show, :edit, :update]
      resolve("Setting") { [:settings] }
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      acts_as_singleton
    RUBY
  end
end
