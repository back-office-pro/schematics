require 'schematics/entities/entity'

describe Schematics::Entities::Entity do
  subject(:entity) do
    described_class.create(name: name, attributes: attributes)
  end

  let(:name) { 'entity' }
  let(:attributes) do
    [
      {
        "name": 'name',
        "type": 'string',
      },
    ]
  end

  its(:icon) { is_expected.to eq(:caret_square_right) }
  its(:class_name) { is_expected.to eq('Entity') }
  its(:weight) { is_expected.to eq(0) }
  its(:viewer) { is_expected.to eq(:table) }

  its(:generators) do
    is_expected.to eq(
      [
        'rails g scaffold entity name:string --skip-resource-route',
        'rails g rspec:acceptance entity',
        'rails g migration add_deleted_at_to_entities deleted_at:datetime',
        'rails g migration add_slug_to_entities slug:string:unique:true',
      ]
    )
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      def search_data
        {
          created_at: created_at,
          name: name&.searchize
        }
      end
    RUBY
  end

  its(:route) do
    is_expected.to eq <<~RUBY
      resources :entities do
        member do
          delete :archive
          delete :restore
        end
        collection do
          post :bulk_insert
          get :import
          get :autocomplete
        end
      end
    RUBY
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
    RUBY
  end
end
