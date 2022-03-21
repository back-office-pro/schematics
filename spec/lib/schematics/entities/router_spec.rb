# frozen_string_literal: true

describe Schematics::Entities::Router do
  subject(:router) { described_class.new(entity) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user', actions:, attributes:) }
  let(:actions) { nil }
  let(:attributes) { [] }

  context 'when no actions are defined' do
    its(:to_str) do
      is_expected.to eq <<~RUBY
        resources :users, only: [:index, :show, :create, :update, :destroy, :new, :edit], param: :id, model_name: 'User' do
          get :delete, on: :member
          delete :archive, on: :member
          delete :restore, on: :member
          get :autocomplete, on: :collection
          post :duplicate, on: :member
          collection do
            resources :imports, only: %i[new create], as: 'user_imports'
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
        resources :users, only: [:index, :show, :create, :update, :destroy, :new, :edit], param: :id, model_name: 'User' do
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
        end
      RUBY
    end
  end

  context 'when some actions are defined' do
    let(:actions) { %w[index show create] }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resources :users, only: [:index, :show, :create, :new], param: :id, model_name: 'User' do
          get :autocomplete, on: :collection
          post :duplicate, on: :member
          collection do
            resources :imports, only: %i[new create], as: 'user_imports'
          end
        end
      RUBY
    end
  end

  context 'when entity is a singleton' do
    let(:entity) { Schematics::Entities::Entity.build(name: 'setting', type: 'singleton') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        resource :settings, only: [:show, :update, :edit]
        resolve("Setting") { [:settings] }
      RUBY
    end
  end
end
