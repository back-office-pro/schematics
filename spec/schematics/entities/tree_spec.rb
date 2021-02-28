require 'schematics/entities/tree'

describe Schematics::Entities::Tree do
  subject(:entity) do
    described_class.create(name: name, attributes: attributes)
  end

  let(:name) { 'directory' }
  let(:attributes) do
    [
      {
        "name": 'name',
        "type": 'string',
      },
    ]
  end

  its(:generators) do
    is_expected.to eq(
      [
        'rails g scaffold directory name:string --skip-resource-route',
        'rails g rspec:acceptance directory',
        'rails g migration add_deleted_at_to_directories deleted_at:datetime',
        'rails g migration add_slug_to_directories slug:string:unique:true',
        'rails g migration add_ancestry_to_directories ancestry:string',
      ]
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_paper_trail ignore: [:id, :created_at, :updated_at, :deleted_at, :slug]
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
