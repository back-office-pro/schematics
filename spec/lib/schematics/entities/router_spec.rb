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
          member do
            resources :comments, only: %i[new create edit update], as: 'user_comments'
          end
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
          member do
            resources :comments, only: %i[new create edit update], as: 'user_comments'
          end
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
          member do
            resources :comments, only: %i[new create edit update], as: 'user_comments'
          end
        end
      RUBY
    end
  end

  context 'when entity is a singleton' do
    let(:entity) { Schematics::Entities::Singleton.new(name: 'setting') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resource :settings, only: [:show, :update, :edit]
        resolve("Setting") { [:settings] }
      RUBY
    end
  end

  context 'when entity has a namespace' do
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
          collection do
            resources :imports, only: %i[new create], as: 'active_storage_attachment_imports'
          end
          member do
            resources :comments, only: %i[new create edit update], as: 'active_storage_attachment_comments'
          end
        end
        end
      RUBY
    end
  end

  context 'when entity is a singleton and has a namespace' do
    let(:entity) { Schematics::Entities::Singleton.new(name: 'main/licence') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        namespace :main do
          resource :licences, only: [:show, :update, :edit]
        end
        resolve("Main::Licence") { [:licences] }
      RUBY
    end
  end
end
