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
      extend Pagy::Searchkick
      has_paper_trail ignore: %i[id created_at updated_at deleted_at read_at slug],
                      versions: { class_name: 'Schematics::Version' }
      acts_as_paranoid
      searchkick searchable: [:company_name],
                 filterable: [:company_name],
                 word_middle: [:company_name],
                 suggest: [:company_name],
                 callbacks: :async
      acts_as_singleton
    RUBY
  end
end
