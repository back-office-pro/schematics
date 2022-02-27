# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Request # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        include Engine.routes.url_helpers
        fixtures :all
        delegate :model_class,
                 :can?,
                 :params,
                 :entity_fixtures,
                 :path,
                 :events,
                 to: :class

        subject { response }

        let(:record) { __send__(entity_fixtures, :one) }
        let(:email) { user.email }
        let(:password) { 'Azerty1!' }
        let(:auth_token) { ::JsonWebToken.encode(auth_token: user.auth_token) }
        let(:headers) { { 'Authorization' => auth_token } } # rubocop:disable Style/StringHashKeys
        let(:role) do
          PaperTrail.request(enabled: false) do
            ::Role.create!(name: 'Admin')
          end
        end
        let(:user) do
          user = users(:two)
          user.update!(locale: Rails.configuration.i18n.default_locale, role:)
          user
        end

        before do
          PaperTrail.request(enabled: false) do
            ::Licence.instance.update!(plan: 'enterprise', expires_at: 12.months.from_now)
          end
        end

        if can?(:index)
          it 'should get index' do
            get path, headers:, as: :html
            is_expected.to have_http_status(:success)
          end

          it 'should get API index' do
            get path, headers:, as: :json
            is_expected.to have_http_status(:success)
          end

          it 'should get CSV index' do
            get path, headers:, as: :csv
            is_expected.to have_http_status(:success)
          end

          it 'should get API autocomplete' do
            get path('autocomplete?field=id'), headers:, as: :json
            is_expected.to have_http_status(:success)
          end
        end

        if can?(:show)
          it 'should show record' do
            get path(record.slug), headers:, as: :html
            is_expected.to have_http_status(:success)
          end

          it 'should show API record' do
            get path(record.slug), headers:, as: :json
            is_expected.to have_http_status(:success)
          end

          it 'should show PDF record' do
            get path(record.slug), headers:, as: :pdf
            is_expected.to have_http_status(:success)
          end

          unless entity.is_a?(Entities::Singleton)
            it 'should redirect to index' do
              get path('abdc'), headers:, as: :html
              is_expected.to redirect_to(path)
            end

            it 'should return 404 code' do
              get path('abdc'), headers:, as: :json
              is_expected.to have_http_status(:not_found)
            end
          end
        end

        if can?(:edit)
          it 'should get edit' do
            get path(record.id, 'edit'), headers:, as: :html
            is_expected.to have_http_status(:success)
          end
        end

        if can?(:new)
          it 'should get new' do
            get path('new'), headers:, as: :html
            is_expected.to have_http_status(:success)
          end
        end

        if can?(:update)
          it 'should update record' do
            patch path(record.id), params: params(record), headers:, as: :html
            is_expected.to redirect_to(path(record.reload.slug))
          end

          it 'should update API record' do
            patch path(record.id), params: params(record, :json), headers:, as: :json
            is_expected.to have_http_status(:success)
          end

          events.each do |event|
            it "should #{event.name} record" do
              patch path(record.id, event.name), headers:, as: :html
              is_expected.to redirect_to(path(record.reload.slug))
            end

            it "should #{event.name} API record" do
              patch path(record.id, event.name), headers:, as: :json
              is_expected.to have_http_status(:no_content)
            end
          end
        end

        if can?(:create)
          it 'should create record' do
            expect { post(path, params: params(record), headers:, as: :html) }
              .to change { model_class.count }
              .by(1)
            is_expected.to redirect_to(path(model_class.last.slug || model_class.last.id))
          end

          it 'should create API record' do
            expect { post(path, params: params(record, :json), headers:, as: :json) }
              .to change { model_class.count }
              .by(1)
            is_expected.to have_http_status(:created)
          end
        end

        if can?(:destroy)
          it 'should get delete' do
            get path(record.id, 'delete'), headers:, as: :html
            is_expected.to have_http_status(:success)
          end

          it 'should destroy record' do
            expect { delete path(record.id), headers:, as: :html }
              .to change { model_class.count }
              .by(-1)
            is_expected.to redirect_to(path)
          end

          it 'should destroy API record' do
            expect { delete path(record.id), headers:, as: :json }
              .to change { model_class.count }
              .by(-1)
            is_expected.to have_http_status(:no_content)
          end
        end

        if can?(:archive)
          it 'should archive record' do
            record.restore
            expect { delete path(record.id, 'archive'), headers:, as: :html }
              .to change { model_class.count }
              .by(-1)
            is_expected.to redirect_to(path)
          end

          it 'should archive API record' do
            record.restore
            expect { delete path(record.id, 'archive'), headers:, as: :json }
              .to change { model_class.count }
              .by(-1)
            is_expected.to have_http_status(:no_content)
          end

          it 'should restore record' do
            record.destroy!
            expect { delete path(record.id, 'restore'), headers:, as: :html }
              .to change { model_class.count }
              .by(1)
            is_expected.to redirect_to(path)
          end

          it 'should restore API record' do
            record.destroy!
            expect { delete path(record.id, 'restore'), headers:, as: :json }
              .to change { model_class.count }
              .by(1)
            is_expected.to have_http_status(:no_content)
          end
        end

        if can?(:import)
          it 'should get new import' do
            get path('imports', 'new'), headers:, as: :html
            is_expected.to have_http_status(:success)
          end
        end
      end

      class_methods do
        delegate :model_class, :original_controller_path, to: :controller_class
        delegate :entity, to: :model_class
        delegate :fillable_elements, :can?, :events, to: :entity

        def controller_class
          description.constantize
        end

        def entity_fixtures
          entity.table_name.pluralize.to_sym
        end

        def params(record, format = nil)
          {
            entity.table_name.to_sym => fillable_elements.to_h do |element|
              [
                element.column_name.to_sym,
                element.public_send([format, 'default'].compact.join('_')) ||
                  record.public_send(element.column_name)
              ]
            end
          }
        end

        def path(*parts)
          case entity
          when Entities::Singleton
            "/#{original_controller_path}"
          else
            parts
              .unshift("/#{original_controller_path}")
              .join('/')
          end
        end
      end
    end
  end
end
