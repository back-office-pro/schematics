# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/enumerable'

module Schematics
  module Specs
    module Request # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        include ResourcesHelper

        delegate :model_class,
                 :model_classes,
                 :entity,
                 :can?,
                 :params,
                 :default,
                 :events,
                 :fillable_attributes,
                 to: :class

        subject { response }

        let(:record) { default.tap(&:save!) }
        let(:access_token) { @session.generate_token_for(:access_token) }
        let(:headers) { { 'Authorization' => "Bearer #{access_token}" } } # rubocop:disable Style/StringHashKeys
        let(:api_key_headers) { { 'x-api-key' => @api_key.access_token } } # rubocop:disable Style/StringHashKeys
        let(:host) { RSpec::Rails::FeatureExampleGroup::DEFAULT_HOST }
        let(:headers_with_referer) { headers.merge('HTTP_REFERER' => edit_profile_url(host:)) } # rubocop:disable Style/StringHashKeys
        let(:ability) { Ability.new(@user) }
        let(:index_path) { resources_path(model_class) }

        before_all do
          PaperTrail.request(enabled: false) do
            @permissions = ::Permission.create_entities_permissions!
            @role = ::Role.create!(name: 'Admin', permissions: @permissions)
            @user = ::User.create!(email: 'john.doe@everywhere.com', role: @role)
            @api_key = ::APIKey.create!(name: 'API key', permissions: @permissions)
            @session = ::Session.create!(user: @user)
          end
        end

        before do
          allow(ActiveRecord::Base).to receive(:lock_optimistically).and_return(false)
          allow_any_instance_of(ActiveStorageValidations::ContentTypeValidator)
            .to receive(:enable_spoofing_protection?)
            .and_return(false)
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
            [headers, api_key_headers].each do |headers|
              get index_path, headers:, as: :json
              status = ability.can?(:index, model_class) ? :success : :forbidden
              is_expected.to have_http_status(status)
            end
          end
        end

        if can?(:show)
          %i[html pdf svg ics].each do |as|
            it "shows #{as.upcase} record" do
              get(resource_path(record), headers:, as:)
              if ability.can?(:show, record)
                is_expected.to have_http_status(:success)
              else
                is_expected.to redirect_to(root_path)
              end
            end
          end

          it 'shows API record' do
            [headers, api_key_headers].each do |headers|
              get resource_path(record), headers:, as: :json
              status = ability.can?(:show, record) ? :success : :forbidden
              is_expected.to have_http_status(status)
            end
          end

          unless entity in Entities::Singleton
            it 'is not found' do
              get resource_path(default), headers:, as: :html
              redirect_path = ability.can?(:index, model_class) ? index_path : root_path
              is_expected.to redirect_to(redirect_path)
            end

            it 'is not found API' do
              [headers, api_key_headers].each do |headers|
                get resource_path(default), headers:, as: :json
                is_expected.to have_http_status(:not_found)
              end
            end
          end

          it 'gets new emailing' do
            get new_emailing_resource_path(record), headers:, as: :html
            if ability.can?(:email, model_class) && ability.can?(:show, record)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'gets new comment' do
            get new_comment_resource_path(record), headers:, as: :html
            if ability.can?(:comment, model_class) && ability.can?(:create, ::Comment)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end
        end

        if can?(:update)
          it 'gets edit' do
            get edit_resource_path(record), headers:, as: :html
            if ability.can?(:edit, record)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'updates record' do
            patch(resource_path(record), params:, headers:)
            redirect_path = ability.can?(:update, record) ? resource_path(record.reload) : root_path
            is_expected.to redirect_to(redirect_path)
          end

          it 'updates API record' do
            [headers, api_key_headers].each do |headers|
              patch resource_path(record), params: params(:json), headers:, as: :json
              status = ability.can?(:update, record) ? :success : :forbidden
              is_expected.to have_http_status(status)
            end
          end

          it 'is a bad request' do
            patch resource_path(record), params: {}, headers: headers_with_referer
            redirect_path = ability.can?(:update, record) ? edit_profile_path : root_path
            is_expected.to redirect_to(redirect_path)
          end

          it 'is a bad request API' do
            [headers, api_key_headers].each do |headers|
              patch resource_path(record), params: {}, headers:, as: :json
              status = ability.can?(:update, record) ? :bad_request : :forbidden
              is_expected.to have_http_status(status)
            end
          end
        end

        if can?(:create)
          it 'gets new' do
            get new_resource_path(model_class), headers:, as: :html
            if ability.can?(:new, model_class)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'gets new import' do
            get new_import_resource_path(model_class), headers:, as: :html
            if ability.can?(:import, model_class)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'creates record' do
            if ability.can?(:create, model_class)
              expect { post index_path, params:, headers: }
                .to change { model_classes.sum(&:count) }
                .by(model_classes.size)
              is_expected.to redirect_to(resource_path(model_class.last))
            else
              expect { post index_path, params:, headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'creates API record' do
            [headers, api_key_headers].each do |headers|
              if ability.can?(:create, model_class)
                expect { post index_path, params: params(:json), headers:, as: :json }
                  .to change { model_classes.sum(&:count) }
                  .by(model_classes.size)
                is_expected.to have_http_status(:created)
                model_class.last.really_destroy!
              else
                expect { post index_path, params: params(:json), headers:, as: :json }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:forbidden)
              end
            end
          end

          it 'is a bad request' do
            post index_path, params: {}, headers: headers_with_referer
            redirect_path = ability.can?(:create, model_class) ? edit_profile_path : root_path
            is_expected.to redirect_to(redirect_path)
          end

          it 'is a bad request API' do
            [headers, api_key_headers].each do |headers|
              post index_path, params: {}, headers:, as: :json
              status = ability.can?(:create, model_class) ? :bad_request : :forbidden
              is_expected.to have_http_status(status)
            end
          end

          it 'duplicates record' do
            if ability.can?(:duplicate, record)
              if fillable_attributes.any?(&:unique?)
                expect { post duplicate_resource_path(record), headers: }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:unprocessable_content)
              else
                expect { post duplicate_resource_path(record), headers: }
                  .to change(model_class, :count)
                  .by(1)
                is_expected.to redirect_to(resource_path(model_class.last))
              end
            else
              expect { post duplicate_resource_path(record, action: :duplicate), headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'duplicates record API' do
            [headers, api_key_headers].each do |headers|
              record
              if ability.can?(:duplicate, record)
                if fillable_attributes.any?(&:unique?)
                  expect { post duplicate_resource_path(record), headers:, as: :json }
                    .not_to change(model_class, :count)
                  is_expected.to have_http_status(:unprocessable_content)
                else
                  expect { post duplicate_resource_path(record), headers:, as: :json }
                    .to change(model_class, :count)
                    .by(1)
                  is_expected.to have_http_status(:created)
                end
              else
                expect { post duplicate_resource_path(record), headers:, as: :json }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:forbidden)
              end
            end
          end
        end

        if can?(:destroy)
          it 'gets delete' do
            get delete_resource_path(record), headers:, as: :html
            if ability.can?(:destroy, record)
              is_expected.to have_http_status(:success)
            else
              is_expected.to redirect_to(root_path)
            end
          end

          it 'destroys record' do
            if ability.can?(:destroy, record)
              expect { delete resource_path(record), headers: }
                .to change(model_class.with_deleted, :count)
                .by(-1)
              is_expected.to redirect_to(index_path)
            else
              expect { delete resource_path(record), headers: }
                .not_to change(model_class.with_deleted, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'destroys API record' do
            [headers, api_key_headers].each do |headers|
              record = default.tap(&:save!)
              if ability.can?(:destroy, record)
                expect { delete resource_path(record), headers:, as: :json }
                  .to change(model_class.with_deleted, :count)
                  .by(-1)
                is_expected.to have_http_status(:no_content)
              else
                expect { delete resource_path(record), headers:, as: :json }
                  .not_to change(model_class.with_deleted, :count)
                is_expected.to have_http_status(:forbidden)
              end
            end
          end
        end

        if can?(:archive)
          it 'archives record' do
            record.restore
            if ability.can?(:archive, record)
              expect { delete archive_resource_path(record), headers: }
                .to change(model_class, :count)
                .by(-1)
              is_expected.to redirect_to(index_path)
            else
              expect { delete archive_resource_path(record), headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'archives API record' do
            [headers, api_key_headers].each do |headers|
              record.restore
              if ability.can?(:archive, record)
                expect { delete archive_resource_path(record), headers:, as: :json }
                  .to change(model_class, :count)
                  .by(-1)
                is_expected.to have_http_status(:no_content)
              else
                expect { delete archive_resource_path(record), headers:, as: :json }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:forbidden)
              end
            end
          end

          it 'restores record' do
            record.destroy!
            if ability.can?(:restore, record)
              expect { delete restore_resource_path(record), headers: }
                .to change(model_class, :count)
                .by(1)
              is_expected.to redirect_to(index_path)
            else
              expect { delete restore_resource_path(record), headers: }
                .not_to change(model_class, :count)
              is_expected.to redirect_to(root_path)
            end
          end

          it 'restores API record' do
            [headers, api_key_headers].each do |headers|
              record.destroy!
              if ability.can?(:restore, record)
                expect { delete restore_resource_path(record), headers:, as: :json }
                  .to change(model_class, :count)
                  .by(1)
                is_expected.to have_http_status(:no_content)
              else
                expect { delete restore_resource_path(record), headers:, as: :json }
                  .not_to change(model_class, :count)
                is_expected.to have_http_status(:forbidden)
              end
            end
          end
        end

        if allow?(:trigger)
          events.each do |event|
            it "#{event.name} record" do
              patch(trigger_resource_path(record, event), headers:)
              if ability.can?(event.name.to_sym, record)
                is_expected.to redirect_to(resource_path(record))
              else
                is_expected.to redirect_to(root_path)
              end
            end

            it "#{event.name} API record" do
              [headers, api_key_headers].each do |headers|
                patch trigger_resource_path(record, event), headers:, as: :json
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
      end

      class_methods do
        delegate :entity, to: :model_class
        delegate :fillable_elements,
                 :fillable_attributes,
                 :events,
                 :default,
                 to: :entity

        def model_class
          top_level_description.constantize
        end

        def allow?(action)
          Array(metadata[:except]).exclude?(action)
        end

        def can?(action)
          entity.can?(action) && allow?(action)
        end

        def model_classes = entity
          .has_many_nested_associations
          .filter_map(&:model_class)
          .push(model_class)

        # :reek:FeatureEnvy
        def params(format = nil)
          { entity.table_name.to_sym => fillable_elements.to_h { nested_params(_1, format) } }
        end

        # :reek:FeatureEnvy
        def nested_params(element, format)
          case element
          when Associations::HasManyNested
            [
              element.attributes_param_key,
              [
                element
                  .entity
                  .fillable_elements
                  .excluding(element.belongs_to)
                  .to_h { nested_params(_1, format) }
              ]
            ]
          else
            [
              element.column_name.to_sym,
              element.public_send([format, 'default'].compact.join('_'))
                .then_tap { _1.tap(&:save!).id if element in Attributes::Association }
                .then_tap { _1.map(&:save!) && _1.map(&:id) if element in Associations::HasAndBelongsToMany } # rubocop:disable Layout/LineLength
            ]
          end
        end
      end
    end
  end
end
