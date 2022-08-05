# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/enumerable'

module Schematics
  module Specs
    module Request # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      CREATE_DENYLIST  = [::Session, ::SchemaDataset, ::Comment].freeze
      SHOW_DENYLIST    = [::ActiveStorage::Attachment, ::Search].freeze
      DESTROY_DENYLIST = [::ActiveStorage::Attachment, ::Session].freeze

      included do
        delegate :root_path,
                 :edit_profile_path,
                 :edit_profile_url,
                 to: 'Schematics::Engine.routes.url_helpers'
        delegate :model_class,
                 :entity,
                 :can?,
                 :params,
                 :default,
                 :path,
                 :events,
                 :fillable_attributes,
                 to: :class

        subject { response }

        let(:record) { default.tap(&:save!) }
        let(:auth_token) { ::JsonWebToken.encode(auth_token: session.auth_token) }
        let(:headers) { { 'Authorization' => auth_token } } # rubocop:disable Style/StringHashKeys
        let(:host) { RSpec::Rails::FeatureExampleGroup::DEFAULT_HOST }
        let(:headers_with_referer) { headers.merge('HTTP_REFERER' => edit_profile_url(host:)) } # rubocop:disable Style/StringHashKeys
        let(:ability) { Ability.new(user) }
        let(:session) { ::Session.create!(user:) }
        let(:role) do
          ::Role.create!(name: 'Admin', permissions: ::Permission.create_all_entities_permissions!)
        end
        let(:user) do
          ::User.create!(
            email: 'admin@admin.com',
            first_name: 'John',
            last_name: 'Doe',
            time_zone: 'Paris',
            locale: Rails.configuration.i18n.default_locale,
            role:
          )
        end

        before do
          allow(ActiveRecord::Base).to receive(:lock_optimistically).and_return(false)
          allow_any_instance_of(::Main::Licence).to receive(:expires_on).and_return(1.day.from_now)
        end

        if can?(:index)
          %i[html csv].each do |as|
            it "should get #{as.upcase} index" do
              get(path, headers:, as:)
              if ability.can?(:index, model_class)
                is_expected.to have_http_status(:success)
              else
                is_expected.to redirect_to(root_path)
              end
            end
          end

          it 'should get API index' do
            get path, headers:, as: :json
            status = ability.can?(:index, model_class) ? :success : :forbidden
            is_expected.to have_http_status(status)
          end

          it 'should get API autocomplete' do
            get path(action: 'autocomplete?field=id'), headers:, as: :json
            status = ability.can?(:index, model_class) ? :success : :forbidden
            is_expected.to have_http_status(status)
          end
        end

        if can?(:show) && SHOW_DENYLIST.exclude?(model_class)
          %i[html pdf svg ics].each do |as|
            it "should show #{as.upcase} record" do
              get(path(record:), headers:, as:)
              if ability.can?(:show, record)
                is_expected.to have_http_status(:success)
              else
                is_expected.to redirect_to(root_path)
              end
            end
          end

          it 'should show API record' do
            get path(record:), headers:, as: :json
            status = ability.can?(:show, record) ? :success : :forbidden
            is_expected.to have_http_status(status)
          end

          unless entity.is_a?(Entities::Singleton)
            it 'should be not found' do
              get path(action: 'foo'), headers:, as: :html
              redirect_path = ability.can?(:index, model_class) ? path : root_path
              is_expected.to redirect_to(redirect_path)
            end

            it 'should be not found API' do
              get path(action: 'foo'), headers:, as: :json
              is_expected.to have_http_status(:not_found)
            end
          end
        end

        if can?(:update)
          it 'should get edit' do
            get path(record:, action: 'edit'), headers:, as: :html
            if ability.can?(:edit, record)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should update record' do
            patch path(record:), params:, headers:, as: :html
            redirect_path = ability.can?(:update, record) ? path(record:) : root_path
            is_expected.to redirect_to(redirect_path)
          end

          it 'should update API record' do
            patch path(record:), params: params(:json), headers:, as: :json
            status = ability.can?(:update, record) ? :success : :forbidden
            is_expected.to have_http_status(status)
          end

          it 'should be a bad request' do
            patch path(record:), params: {}, headers: headers_with_referer, as: :html
            redirect_path = ability.can?(:update, record) ? edit_profile_path : root_path
            is_expected.to redirect_to(redirect_path)
          end

          it 'should be a bad request API' do
            patch path(record:), params: {}, headers:, as: :json
            status = ability.can?(:update, record) ? :bad_request : :forbidden
            is_expected.to have_http_status(status)
          end
        end

        if can?(:create) && CREATE_DENYLIST.exclude?(model_class)
          it 'should get new' do
            get path(action: 'new'), headers:, as: :html
            if ability.can?(:new, model_class)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should get new import' do
            get path(action: 'imports/new'), headers:, as: :html
            if ability.can?(:import, model_class)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should create record' do
            if ability.can?(:create, model_class)
              expect { post(path, params:, headers:, as: :html) }
                .to change(model_class, :count)
                .by(1)
              is_expected.to redirect_to(path(record: model_class.last))
            else
              expect { post(path, params:, headers:, as: :html) }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should create API record' do
            if ability.can?(:create, model_class)
              expect { post(path, params: params(:json), headers:, as: :json) }
                .to change(model_class, :count)
                .by(1)
              is_expected.to have_http_status(:created)
            else
              expect { post(path, params: params(:json), headers:, as: :json) }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end

          it 'should be a bad request' do
            post path, params: {}, headers: headers_with_referer, as: :html
            redirect_path = ability.can?(:create, model_class) ? edit_profile_path : root_path
            is_expected.to redirect_to(redirect_path)
          end

          it 'should be a bad request API' do
            post path, params: {}, headers:, as: :json
            status = ability.can?(:create, model_class) ? :bad_request : :forbidden
            is_expected.to have_http_status(status)
          end

          it 'should duplicate record' do
            if ability.can?(:duplicate, record)
              if fillable_attributes.any?(&:unique?)
                expect { post(path(record:, action: 'duplicate'), headers:, as: :html) }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:unprocessable_entity)
              else
                expect { post(path(record:, action: 'duplicate'), headers:, as: :html) }
                  .to change(model_class, :count)
                  .by(1)
                is_expected.to redirect_to(path(record: model_class.last))
              end
            else
              expect { post(path(record:, action: 'duplicate'), headers:, as: :html) }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should duplicate record API' do
            if ability.can?(:duplicate, record)
              if fillable_attributes.any?(&:unique?)
                expect { post(path(record:, action: 'duplicate'), headers:, as: :json) }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:unprocessable_entity)
              else
                expect { post(path(record:, action: 'duplicate'), headers:, as: :json) }
                  .to change(model_class, :count)
                  .by(1)
                is_expected.to have_http_status(:created)
              end
            else
              expect { post(path(record:, action: 'duplicate'), headers:, as: :json) }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end
        end

        if can?(:destroy) && DESTROY_DENYLIST.exclude?(model_class)
          it 'should get delete' do
            get path(record:, action: 'delete'), headers:, as: :html
            if ability.can?(:destroy, record)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should destroy record' do
            if ability.can?(:destroy, record)
              expect { delete path(record:), headers:, as: :html }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to redirect_to(path)
            else
              expect { delete path(record:), headers:, as: :html }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should destroy API record' do
            if ability.can?(:destroy, record)
              expect { delete path(record:), headers:, as: :json }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to have_http_status(:no_content)
            else
              expect { delete path(record:), headers:, as: :json }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end
        end

        if can?(:archive)
          it 'should archive record' do
            record.restore
            if ability.can?(:archive, record)
              expect { delete path(record:, action: 'archive'), headers:, as: :html }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to redirect_to(path)
            else
              expect { delete path(record:, action: 'archive'), headers:, as: :html }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should archive API record' do
            record.restore
            if ability.can?(:archive, record)
              expect { delete path(record:, action: 'archive'), headers:, as: :json }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to have_http_status(:no_content)
            else
              expect { delete path(record:, action: 'archive'), headers:, as: :json }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end

          it 'should restore record' do
            record.destroy!
            if ability.can?(:restore, record)
              expect { delete path(record:, action: 'restore'), headers:, as: :html }
                .to change(model_class, :count)
                .by(1)
              is_expected.to redirect_to(path)
            else
              expect { delete path(record:, action: 'restore'), headers:, as: :html }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'should restore API record' do
            record.destroy!
            if ability.can?(:restore, record)
              expect { delete path(record:, action: 'restore'), headers:, as: :json }
                .to change(model_class, :count)
                .by(1)
              is_expected.to have_http_status(:no_content)
            else
              expect { delete path(record:, action: 'restore'), headers:, as: :json }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end
        end

        events.each do |event|
          it "should #{event.name} record" do
            patch path(record:, action: event.name), headers:, as: :html
            if ability.can?(event.name.to_sym, record)
              is_expected.to redirect_to(path(record:))
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it "should #{event.name} API record" do
            patch path(record:, action: event.name), headers:, as: :json
            if ability.can?(event.name.to_sym, record)
              status = record.public_send(:"may_#{event.name}?") ? :no_content : :method_not_allowed
              is_expected.to have_http_status(status)
            else
              is_expected.to have_http_status(:forbidden)
            end
          end
        end
      end

      class_methods do
        delegate :model_class, :controller_path, to: :controller_class
        delegate :entity, to: :model_class
        delegate :fillable_elements,
                 :fillable_attributes,
                 :can?,
                 :events,
                 :default,
                 to: :entity

        def controller_class
          description.constantize
        end

        # :reek:FeatureEnvy
        def params(format = nil)
          {
            entity.table_name.to_sym => fillable_elements.to_h do |element|
              [
                element.column_name.to_sym,
                element.public_send([format, 'default'].compact.join('_'))
                       .then_tap { _1.save! && _1.id if element.is_a?(Attributes::Association) }
              ]
            end
          }
        end

        def path(record: nil, action: nil)
          [
            "/#{controller_path}",
            (record&.slug || record&.id unless entity.is_a?(Entities::Singleton)),
            action
          ].compact.join('/')
        end
      end
    end
  end
end
