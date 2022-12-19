# frozen_string_literal: true

describe Schematics::Entities::Router do
  subject(:router) { described_class.new(entity) }

  let(:entity) { Schematics::Entities::Entity.new(name:, options:, attributes:) }
  let(:name) { 'user' }
  let(:options) { { actions: } }
  let(:actions) { nil }
  let(:attributes) { [] }

  context 'when no actions are defined' do
    its(:to_str) do
      is_expected.to eq <<~RUBY
        resources :users, only: [:index, :show, :create, :update, :destroy, :new, :edit], model_name: 'User' do
          get :delete, on: :member
          delete :archive, on: :member
          delete :restore, on: :member
          get :autocomplete, on: :collection
          post :duplicate, on: :member
          collection do
            resources :imports, only: %i[new create], as: 'user_imports'
          end
          resources :comments, only: %i[new create edit update], shallow: true
        end
      RUBY
    end
  end

  context 'when no actions are defined but entity has events' do
    let(:attributes) do
      [
        {
          name: 'state',
          type: 'state_machine',
          options: {
            default: 'pending',
            values: %w[
              pending
              closed
              refused
            ],
            events: [
              {
                name: 'close',
                from: 'pending',
                to: 'closed'
              },
              {
                name: 'refuse',
                from: 'pending',
                to: 'refused'
              },
              {
                name: 'reopen',
                from: %w[
                  closed
                  refused
                ],
                to: 'pending'
              }
            ]
          }
        }
      ]
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resources :users, only: [:index, :show, :create, :update, :destroy, :new, :edit], model_name: 'User' do
          get :delete, on: :member
          delete :archive, on: :member
          delete :restore, on: :member
          get :autocomplete, on: :collection
          post :duplicate, on: :member
          patch :close, action: :trigger, event: 'close', on: :member
          patch :refuse, action: :trigger, event: 'refuse', on: :member
          patch :reopen, action: :trigger, event: 'reopen', on: :member
          collection do
            resources :imports, only: %i[new create], as: 'user_imports'
          end
          resources :comments, only: %i[new create edit update], shallow: true
        end
      RUBY
    end
  end

  context 'when some actions are defined' do
    let(:actions) { %w[index show create] }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resources :users, only: [:index, :show, :create, :new], model_name: 'User' do
          get :autocomplete, on: :collection
          post :duplicate, on: :member
          collection do
            resources :imports, only: %i[new create], as: 'user_imports'
          end
          resources :comments, only: %i[new create edit update], shallow: true
        end
      RUBY
    end
  end

  context 'when entity is a singleton' do
    let(:entity) { Schematics::Entities::Singleton.new(name: 'configuration') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resource :configuration, only: [:show, :update, :edit], model_name: 'Configuration' do
          resources :comments, only: %i[new create edit update], shallow: true
        end
        resolve "Configuration" do |resource, options|
          [:configuration, options]
        end
      RUBY
    end
  end

  context 'when entity has a one-level namespace' do
    let(:name) { 'active_storage/blob' }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        namespace :active_storage do
          resources :blobs, only: [:index, :show, :create, :update, :destroy, :new, :edit], model_name: 'ActiveStorage::Blob' do
          get :delete, on: :member
          delete :archive, on: :member
          delete :restore, on: :member
          get :autocomplete, on: :collection
          post :duplicate, on: :member
          collection do
            resources :imports, only: %i[new create], as: 'active_storage_blob_imports'
          end
          resources :comments, only: %i[new create edit update], shallow: true
        end
        end
      RUBY
    end
  end

  context 'when entity has a three-levels namespace' do
    let(:name) { 'i18n/backend/active_record/translation' }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        namespace :i18n do
          namespace :backend do
          namespace :active_record do
          resources :translations, only: [:index, :show, :create, :update, :destroy, :new, :edit], model_name: 'I18n::Backend::ActiveRecord::Translation' do
          get :delete, on: :member
          delete :archive, on: :member
          delete :restore, on: :member
          get :autocomplete, on: :collection
          post :duplicate, on: :member
          collection do
            resources :imports, only: %i[new create], as: 'i18n_backend_active_record_translation_imports'
          end
          resources :comments, only: %i[new create edit update], shallow: true
        end
        end
        end
        end
      RUBY
    end
  end

  context 'when entity is a singleton and has a one-level namespace' do
    let(:entity) { Schematics::Entities::Singleton.new(name: 'main/licence') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        namespace :main do
          resource :licence, only: [:show, :update, :edit], model_name: 'Main::Licence' do
          resources :comments, only: %i[new create edit update], shallow: true
        end
        end
        resolve "Main::Licence" do |resource, options|
          [:licence, options]
        end
      RUBY
    end
  end
end
