# frozen_string_literal: true

describe Schematics::Entities::Entity do
  subject(:entity) do
    described_class.create(name: name, attributes: attributes)
  end

  let(:name) { 'entity' }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      }
    ]
  end

  its(:icon) { is_expected.to eq(:caret_square_right) }
  its(:class_name) { is_expected.to eq('Entity') }
  its(:weight) { is_expected.to eq(0) }
  its(:viewer) { is_expected.to eq(:table) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      def search_data
        {
          created_at: created_at,
          name: name&.to_s
        }
      end
    RUBY
  end

  its(:route) do
    is_expected.to eq <<~RUBY
      resources :entities, model_name: 'Entity' do
        member do
          get :delete
          delete :archive
          delete :restore
        end
        collection do
          get :autocomplete
          resources :imports, only: %i[new create], as: 'entity_imports', format: false do
            get :template, on: :collection, format: :csv
          end
        end
      end
    RUBY
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
    RUBY
  end
end
