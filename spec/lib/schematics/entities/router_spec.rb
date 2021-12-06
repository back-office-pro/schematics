# frozen_string_literal: true

describe Schematics::Entities::Router do
  subject(:router) { described_class.new(entity) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user', actions: actions) }

  context 'when no actions are defined' do
    let(:actions) { nil }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resources :users, only: [:index, :show, :create, :new, :edit, :update, :destroy], model_name: 'User' do
          get :delete, on: :member
          delete :archive, on: :member
          delete :restore, on: :member
          get :autocomplete, on: :collection
          collection do
            resources :imports, only: %i[new create], as: 'user_imports', format: false do
              get :template, on: :collection, format: :csv
            end
          end
        end
      RUBY
    end
  end

  context 'when some actions are defined' do
    let(:actions) { %w[index show create import] }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resources :users, only: [:index, :show, :create], model_name: 'User' do
          get :autocomplete, on: :collection
          collection do
            resources :imports, only: %i[new create], as: 'user_imports', format: false do
              get :template, on: :collection, format: :csv
            end
          end
        end
      RUBY
    end
  end

  context 'when entity is a singleton' do
    let(:entity) { Schematics::Entities::Entity.build(name: 'setting', type: 'singleton') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resource :settings, only: [:show, :edit, :update]
        resolve("Setting") { [:settings] }
      RUBY
    end
  end
end
