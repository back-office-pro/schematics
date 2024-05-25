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
        end
        resources :users, only: [], model_name: 'User' do
          collection do
            resources :imports, only: %i[new create], as: 'user_imports'
          end
          collection do
            resources :comparisons, only: :create, as: 'user_comparisons'
          end
          collection do
            resource :bulk_actions, only: [], as: 'user_bulk_actions' do
              post :archive, controller: 'schematics/bulk_actions'
            end
          end
          resources :comments, only: %i[new create]
          resources :emailings, only: %i[new create]
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
          patch 'state/close', action: :trigger, event: 'close_state', on: :member
          patch 'state/refuse', action: :trigger, event: 'refuse_state', on: :member
          patch 'state/reopen', action: :trigger, event: 'reopen_state', on: :member
        end
        resources :users, only: [], model_name: 'User' do
          collection do
            resources :imports, only: %i[new create], as: 'user_imports'
          end
          collection do
            resources :comparisons, only: :create, as: 'user_comparisons'
          end
          collection do
            resource :bulk_actions, only: [], as: 'user_bulk_actions' do
              post :archive, controller: 'schematics/bulk_actions'
            end
          end
          resources :comments, only: %i[new create]
          resources :emailings, only: %i[new create]
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
        end
        resources :users, only: [], model_name: 'User' do
          collection do
            resources :imports, only: %i[new create], as: 'user_imports'
          end
          collection do
            resources :comparisons, only: :create, as: 'user_comparisons'
          end
          resources :comments, only: %i[new create]
          resources :emailings, only: %i[new create]
        end
      RUBY
    end
  end

  context 'when entity is a singleton' do
    let(:entity) { Schematics::Entities::Singleton.new(name: 'configuration') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resource :configuration, only: [:show, :update, :edit], model_name: 'Configuration' do

        end
        resource :configuration, only: [], model_name: 'Configuration' do
          resources :comments, only: %i[new create]
          resources :emailings, only: %i[new create]
        end
        resolve 'Configuration' do |resource, options|
          [:configuration, options]
        end
      RUBY
    end
  end

  context 'when entity has a one-level namespace' do
    let(:name) { 'active_storage/attachment' }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        namespace :active_storage do
          resources :attachments, only: [:index, :show, :create, :update, :destroy, :new, :edit], model_name: 'ActiveStorage::Attachment' do
            get :delete, on: :member
            delete :archive, on: :member
            delete :restore, on: :member
            get :autocomplete, on: :collection
            post :duplicate, on: :member
          end
        end
        scope path: :active_storage, as: :active_storage do
          resources :attachments, only: [], model_name: 'ActiveStorage::Attachment' do
            collection do
              resources :imports, only: %i[new create], as: 'attachment_imports'
            end
            collection do
              resources :comparisons, only: :create, as: 'attachment_comparisons'
            end
            collection do
              resource :bulk_actions, only: [], as: 'attachment_bulk_actions' do
                post :archive, controller: 'schematics/bulk_actions'
              end
            end
            resources :comments, only: %i[new create]
            resources :emailings, only: %i[new create]
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
              end
            end
          end
        end
        scope path: :i18n, as: :i18n do
          scope path: :backend, as: :backend do
            scope path: :active_record, as: :active_record do
              resources :translations, only: [], model_name: 'I18n::Backend::ActiveRecord::Translation' do
                collection do
                  resources :imports, only: %i[new create], as: 'translation_imports'
                end
                collection do
                  resources :comparisons, only: :create, as: 'translation_comparisons'
                end
                collection do
                  resource :bulk_actions, only: [], as: 'translation_bulk_actions' do
                    post :archive, controller: 'schematics/bulk_actions'
                  end
                end
                resources :comments, only: %i[new create]
                resources :emailings, only: %i[new create]
              end
            end
          end
        end
      RUBY
    end
  end

  context 'when entity is a singleton and has a one-level namespace' do
    let(:entity) { Schematics::Entities::Singleton.new(name: 'main/subscription') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        namespace :main do
          resource :subscription, only: [:show, :update, :edit], model_name: 'Main::Subscription' do

          end
        end
        scope path: :main, as: :main do
          resource :subscription, only: [], model_name: 'Main::Subscription' do
            resources :comments, only: %i[new create]
            resources :emailings, only: %i[new create]
          end
        end
        resolve 'Main::Subscription' do |resource, options|
          [:subscription, options]
        end
      RUBY
    end
  end
end
