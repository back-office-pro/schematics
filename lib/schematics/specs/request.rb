# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/enumerable'

module Schematics
  module Specs
    module Request # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        include Rails.application.routes.url_helpers
        delegate :root_path,
                 :edit_profile_path,
                 :edit_profile_url,
                 to: 'Schematics::Engine.routes.url_helpers'
        delegate :model_class,
                 :entity,
                 :can?,
                 :params,
                 :default,
                 :events,
                 :fillable_attributes,
                 to: :class

        subject { response }

        let(:record) { default.tap(&:save!) }
        let(:route_key) { [model_class.model_name.singular_route_key.to_sym] }
        let(:auth_token) { JWT::AuthToken.encode(session.auth_token) }
        let(:headers) { { 'Authorization' => "Bearer #{auth_token}" } } # rubocop:disable Style/StringHashKeys
        let(:host) { RSpec::Rails::FeatureExampleGroup::DEFAULT_HOST }
        let(:headers_with_referer) { headers.merge('HTTP_REFERER' => edit_profile_url(host:)) } # rubocop:disable Style/StringHashKeys
        let(:ability) { Ability.new(user) }
        let(:session) { ::Session.create!(user:) }
        let(:index_path) { polymorphic_path(model_class) }
        let(:role) do
          ::Role.create!(name: 'Admin', permissions: ::Permission.create_entities_permissions!)
        end
        let(:user) do
          ::User.create!(email: 'admin@admin.com', first_name: 'John', last_name: 'Doe', role:)
        end

        before do
          allow(ActiveRecord::Base).to receive(:lock_optimistically).and_return(false)
        end

        if can?(:index)
          %i[html csv].each do |as|
            it "gets #{as.upcase} index" do
              get(index_path, headers:, as:)
              if ability.can?(:index, model_class)
                is_expected.to have_http_status(:success)
              else
                is_expected.to redirect_to(root_path)
              end
            end
          end

          it 'gets API index' do
            get index_path, headers:, as: :json
            status = ability.can?(:index, model_class) ? :success : :forbidden
            is_expected.to have_http_status(status)
          end

          it 'gets API autocomplete' do
            get polymorphic_path(model_class, action: :autocomplete, field: 'id'),
                headers:,
                as: :json
            status = ability.can?(:index, model_class) ? :success : :forbidden
            is_expected.to have_http_status(status)
          end
        end

        if can?(:show)
          %i[html pdf svg ics].each do |as|
            it "shows #{as.upcase} record" do
              get(polymorphic_path(record), headers:, as:)
              if ability.can?(:show, record)
                is_expected.to have_http_status(:success)
              else
                is_expected.to redirect_to(root_path)
              end
            end
          end

          it 'shows API record' do
            get polymorphic_path(record), headers:, as: :json
            status = ability.can?(:show, record) ? :success : :forbidden
            is_expected.to have_http_status(status)
          end

          if !entity.is_a?(Entities::Singleton) && allow?(:not_found)
            it 'is not found' do
              get polymorphic_path(route_key, id: 'foo'), headers:, as: :html
              redirect_path = ability.can?(:index, model_class) ? index_path : root_path
              is_expected.to redirect_to(redirect_path)
            end

            it 'is not found API' do
              get polymorphic_path(route_key, id: 'foo'), headers:, as: :json
              is_expected.to have_http_status(:not_found)
            end
          end
        end

        if can?(:update)
          it 'gets edit' do
            get edit_polymorphic_path(record), headers:, as: :html
            if ability.can?(:edit, record)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'updates record' do
            patch(polymorphic_path(record), params:, headers:)
            redirect_path = ability.can?(:update, record) ? polymorphic_path(record.reload) : root_path # rubocop:disable Layout/LineLength
            is_expected.to redirect_to(redirect_path)
          end

          it 'updates API record' do
            patch polymorphic_path(record), params: params(:json), headers:, as: :json
            status = ability.can?(:update, record) ? :success : :forbidden
            is_expected.to have_http_status(status)
          end

          it 'is a bad request' do
            patch polymorphic_path(record), params: {}, headers: headers_with_referer
            redirect_path = ability.can?(:update, record) ? edit_profile_path : root_path
            is_expected.to redirect_to(redirect_path)
          end

          it 'is a bad request API' do
            patch polymorphic_path(record), params: {}, headers:, as: :json
            status = ability.can?(:update, record) ? :bad_request : :forbidden
            is_expected.to have_http_status(status)
          end
        end

        if can?(:create)
          it 'gets new' do
            get new_polymorphic_path(model_class), headers:, as: :html
            if ability.can?(:new, model_class)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'gets new import' do
            get new_polymorphic_path([model_class, ::Import], format: nil), headers:, as: :html
            if ability.can?(:import, model_class)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'creates record' do
            if ability.can?(:create, model_class)
              expect { post index_path, params:, headers: }
                .to change(model_class, :count)
                .by(1)
              is_expected.to redirect_to(polymorphic_path(model_class.last))
            else
              expect { post index_path, params:, headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'creates API record' do
            if ability.can?(:create, model_class)
              expect { post index_path, params: params(:json), headers:, as: :json }
                .to change(model_class, :count)
                .by(1)
              is_expected.to have_http_status(:created)
            else
              expect { post index_path, params: params(:json), headers:, as: :json }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end

          it 'is a bad request' do
            post index_path, params: {}, headers: headers_with_referer
            redirect_path = ability.can?(:create, model_class) ? edit_profile_path : root_path
            is_expected.to redirect_to(redirect_path)
          end

          it 'is a bad request API' do
            post index_path, params: {}, headers:, as: :json
            status = ability.can?(:create, model_class) ? :bad_request : :forbidden
            is_expected.to have_http_status(status)
          end

          it 'duplicates record' do
            if ability.can?(:duplicate, record)
              if fillable_attributes.any?(&:unique?)
                expect { post polymorphic_path(record, action: :duplicate), headers: }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:unprocessable_entity)
              else
                expect { post polymorphic_path(record, action: :duplicate), headers: }
                  .to change(model_class, :count)
                  .by(1)
                is_expected.to redirect_to(polymorphic_path(model_class.last))
              end
            else
              expect { post polymorphic_path(record, action: :duplicate), headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'duplicates record API' do
            if ability.can?(:duplicate, record)
              if fillable_attributes.any?(&:unique?)
                expect { post polymorphic_path(record, action: :duplicate), headers:, as: :json }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:unprocessable_entity)
              else
                expect { post polymorphic_path(record, action: :duplicate), headers:, as: :json }
                  .to change(model_class, :count)
                  .by(1)
                is_expected.to have_http_status(:created)
              end
            else
              expect { post polymorphic_path(record, action: :duplicate), headers:, as: :json }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end
        end

        if can?(:destroy)
          it 'gets delete' do
            get polymorphic_path(record, action: :delete), headers:, as: :html
            if ability.can?(:destroy, record)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'destroys record' do
            if ability.can?(:destroy, record)
              expect { delete polymorphic_path(record), headers: }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to redirect_to(index_path)
            else
              expect { delete polymorphic_path(record), headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'destroys API record' do
            if ability.can?(:destroy, record)
              expect { delete polymorphic_path(record), headers:, as: :json }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to have_http_status(:no_content)
            else
              expect { delete polymorphic_path(record), headers:, as: :json }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end
        end

        if can?(:archive)
          it 'archives record' do
            record.restore
            if ability.can?(:archive, record)
              expect { delete polymorphic_path(record, action: :archive), headers: }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to redirect_to(index_path)
            else
              expect { delete polymorphic_path(record, action: :archive), headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'archives API record' do
            record.restore
            if ability.can?(:archive, record)
              expect { delete polymorphic_path(record, action: :archive), headers:, as: :json }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to have_http_status(:no_content)
            else
              expect { delete polymorphic_path(record, action: :archive), headers:, as: :json }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end

          it 'restores record' do
            record.destroy!
            if ability.can?(:restore, record)
              expect { delete polymorphic_path(record, action: :restore), headers: }
                .to change(model_class, :count)
                .by(1)
              is_expected.to redirect_to(index_path)
            else
              expect { delete polymorphic_path(record, action: :restore), headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'restores API record' do
            record.destroy!
            if ability.can?(:restore, record)
              expect { delete polymorphic_path(record, action: :restore), headers:, as: :json }
                .to change(model_class, :count)
                .by(1)
              is_expected.to have_http_status(:no_content)
            else
              expect { delete polymorphic_path(record, action: :restore), headers:, as: :json }
                .not_to change(model_class, :count)
              is_expected.to have_http_status(:forbidden)
            end
          end
        end

        if allow?(:trigger)
          events.each do |event|
            it "#{event.name} record" do
              patch(polymorphic_path([event.state_machine_name.to_sym, event.name.to_sym, record], format: nil), headers:) # rubocop:disable Layout/LineLength
              if ability.can?(event.name.to_sym, record)
                is_expected.to redirect_to(polymorphic_path(record))
              else
                is_expected.to redirect_to(root_path)
              end
            end

            it "#{event.name} API record" do
              patch polymorphic_path([event.state_machine_name.to_sym, event.name.to_sym, record], format: nil), # rubocop:disable Layout/LineLength
                    headers:,
                    as: :json
              if ability.can?(event.name.to_sym, record)
                status = record.public_send(:"may_#{event.suffixed_name}?") ? :no_content : :method_not_allowed # rubocop:disable Layout/LineLength
                is_expected.to have_http_status(status)
              else
                is_expected.to have_http_status(:forbidden)
              end
            end
          end
        end
      end

      class_methods do
        delegate :model_class, to: :controller_class
        delegate :entity, to: :model_class
        delegate :fillable_elements,
                 :fillable_attributes,
                 :events,
                 :default,
                 to: :entity

        def controller_class
          top_level_description.constantize
        end

        def allow?(action)
          Array(metadata[:except]).exclude?(action)
        end

        def can?(action)
          entity.can?(action) && allow?(action)
        end

        # :reek:FeatureEnvy
        def params(format = nil) # rubocop:disable Metrics/CyclomaticComplexity
          {
            entity.table_name.to_sym => fillable_elements.to_h do |element|
              [
                element.column_name.to_sym,
                element.public_send([format, 'default'].compact.join('_'))
                       .then_tap { _1.save! && _1.id if element.is_a?(Attributes::Association) }
                       .then_tap { _1.map(&:save!) && _1.map(&:id) if element.is_a?(Associations::HasAndBelongsToMany) } # rubocop:disable Layout/LineLength
              ]
            end
          }
        end
      end
    end
  end
end
