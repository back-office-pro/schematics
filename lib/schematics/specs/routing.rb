# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Routing # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        include ResourcesHelper
        delegate :model_class,
                 :controller,
                 :locale,
                 :can?,
                 :events,
                 :default,
                 to: :class

        let(:record) { default.tap(&:save!) }
        let(:params) { { locale:, controller: } }
        let(:model_params) { model_class.route_params.merge(params) }
        let(:record_params) { record.route_params.merge(params) }

        before do
          allow_any_instance_of(ActiveStorageValidations::ContentTypeValidator)
            .to receive(:enable_spoofing_protection?)
            .and_return(false)
        end

        it do
          if can?(:index)
            is_expected
              .to route(:get, resources_path(model_class))
              .to model_params.merge(action: :index)
            is_expected
              .to route(:post, autocomplete_resource_path(model_class))
              .to model_params.merge(controller: 'schematics/autocompletions', action: :create)
            is_expected
              .to route(:post, compare_resource_path(model_class))
              .to model_params.merge(controller: :comparisons, action: :create)
          end
          if can?(:show)
            is_expected
              .to route(:get, resource_path(record))
              .to record_params.merge(action: :show)
            is_expected
              .to route(:get, new_comment_resource_path(record))
              .to record_params.merge(controller: :comments, action: :new)
            is_expected
              .to route(:post, comment_resource_path(record))
              .to record_params.merge(controller: :comments, action: :create)
            is_expected
              .to route(:get, new_emailing_resource_path(record))
              .to record_params.merge(controller: :emailings, action: :new)
            is_expected
              .to route(:post, emailing_resource_path(record))
              .to record_params.merge(controller: :emailings, action: :create)
          end
          if can?(:create)
            is_expected
              .to route(:get, new_resource_path(model_class))
              .to model_params.merge(action: :new)
            is_expected
              .to route(:post, resources_path(model_class))
              .to model_params.merge(action: :create)
            is_expected
              .to route(:post, duplicate_resource_path(record))
              .to record_params.merge(action: :duplicate)
            is_expected
              .to route(:get, new_import_resource_path(model_class))
              .to model_params.merge(controller: :imports, action: :new)
            is_expected
              .to route(:post, import_resource_path(model_class))
              .to model_params.merge(controller: :imports, action: :create)
          end
          if can?(:update)
            is_expected
              .to route(:get, edit_resource_path(record))
              .to record_params.merge(action: :edit)
            is_expected
              .to route(:patch, resource_path(record))
              .to record_params.merge(action: :update)
          end
          if can?(:destroy)
            is_expected
              .to route(:delete, resource_path(record))
              .to record_params.merge(action: :destroy)
            is_expected
              .to route(:get, delete_resource_path(record))
              .to record_params.merge(action: :delete)
          end
          if can?(:archive)
            is_expected
              .to route(:delete, archive_resource_path(record))
              .to record_params.merge(action: :archive)
            is_expected
              .to route(:delete, restore_resource_path(record))
              .to record_params.merge(action: :restore)
            is_expected
              .to route(:post, bulk_resource_path(model_class))
              .to model_params.merge(controller: 'schematics/bulk_actions', action: :create)
          end
          events.each do |event|
            is_expected
              .to route(:patch, trigger_resource_path(record, event))
              .to record_params.merge(
                action: :trigger,
                state: event.state_machine_name,
                event: event.name
              )
          end
        end
      end

      class_methods do
        delegate :entity, to: :model_class
        delegate :events, :default, to: :entity

        def model_class
          top_level_description.constantize
        end

        def controller = 'schematics/routing'

        def allow?(action)
          Array(metadata[:except]).exclude?(action)
        end

        def can?(action)
          entity.can?(action) && allow?(action)
        end

        # :reek:UtilityFunction
        def locale = Rails
          .configuration
          .i18n
          .default_locale
      end
    end
  end
end
