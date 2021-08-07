# frozen_string_literal: true

describe Schematics::Entities::Tree do
  subject(:entity) do
    described_class.create(name: name, attributes: attributes)
  end

  let(:name) { 'directory' }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      }
    ]
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      extend Pagy::Searchkick
      has_paper_trail ignore: %i[id created_at updated_at deleted_at read_at slug],
                      versions: { class_name: 'Schematics::Version' }
      acts_as_paranoid
      searchkick searchable: [:name],
                 filterable: [:name],
                 word_middle: [:name],
                 suggest: [:name],
                 callbacks: :async
      has_ancestry
    RUBY
  end
end
