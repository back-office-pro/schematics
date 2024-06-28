# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Routing # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        include Rails.application.routes.url_helpers
        delegate :model_class,
                 :controller,
                 :model_name,
                 :locale,
                 :can?,
                 :events,
                 :default,
                 to: :class

        let(:record) { default.tap(&:save!) }
        let(:id) { record.to_param unless record in ::Singleton }
        let(:parent_id) { :"#{model_class.model_name.param_key}_id" }
        let(:params) { { locale:, model_name:, controller: } }

        it do
          if can?(:index)
            is_expected
              .to route(:get, polymorphic_path(model_class))
              .to params.merge(action: :index)
            is_expected
              .to route(:get, polymorphic_path(model_class, action: :autocomplete))
              .to params.merge(action: :autocomplete)
            is_expected
              .to route(:post, polymorphic_path([model_class, ::Comparison], format: nil))
              .to params.merge(controller: :comparisons, action: :create)
          end
          if can?(:show)
            is_expected
              .to route(:get, polymorphic_path(record))
              .to params.merge(action: :show, id:).compact
            is_expected
              .to route(:get, new_polymorphic_path([record, ::Comment], format: nil))
              .to params.merge(controller: :comments, parent_id => id, action: :new).compact
            is_expected
              .to route(:post, polymorphic_path([record, ::Comment], format: nil))
              .to params.merge(controller: :comments, parent_id => id, action: :create).compact
            is_expected
              .to route(:get, new_polymorphic_path([record, ::Emailing], format: nil))
              .to params.merge(controller: :emailings, parent_id => id, action: :new).compact
            is_expected
              .to route(:post, polymorphic_path([record, ::Emailing], format: nil))
              .to params.merge(controller: :emailings, parent_id => id, action: :create).compact
            is_expected
              .to route(:get, new_polymorphic_path([record, ::Alert], format: nil))
              .to params.merge(controller: :alerts, parent_id => id, action: :new).compact
            is_expected
              .to route(:post, polymorphic_path([record, ::Alert], format: nil))
              .to params.merge(controller: :alerts, parent_id => id, action: :create).compact
          end
          if can?(:create)
            is_expected
              .to route(:get, new_polymorphic_path(model_class))
              .to params.merge(action: :new)
            is_expected
              .to route(:post, polymorphic_path(model_class))
              .to params.merge(action: :create)
            is_expected
              .to route(:post, polymorphic_path(record, action: :duplicate))
              .to params.merge(id:, action: :duplicate)
            is_expected
              .to route(:get, new_polymorphic_path([model_class, ::Import], format: nil))
              .to params.merge(controller: :imports, action: :new)
            is_expected
              .to route(:post, polymorphic_path([model_class, ::Import], format: nil))
              .to params.merge(controller: :imports, action: :create)
          end
          if can?(:update)
            is_expected
              .to route(:get, edit_polymorphic_path(record))
              .to params.merge(id:, action: :edit).compact
            is_expected
              .to route(:patch, polymorphic_path(record))
              .to params.merge(id:, action: :update).compact
          end
          if can?(:destroy)
            is_expected
              .to route(:delete, polymorphic_path(record))
              .to params.merge(id:, action: :destroy)
            is_expected
              .to route(:get, polymorphic_path(record, action: :delete))
              .to params.merge(id:, action: :delete)
          end
          if can?(:archive)
            is_expected
              .to route(:delete, polymorphic_path(record, action: :archive))
              .to params.merge(id:, action: :archive)
            is_expected
              .to route(:delete, polymorphic_path(record, action: :restore))
              .to params.merge(id:, action: :restore)
            is_expected
              .to route(:post, polymorphic_path([model_class, :bulk_actions], format: nil))
              .to params.merge(controller: 'schematics/bulk_actions', action: :create)
          end
          events.each do |event|
            is_expected
              .to route(:patch, polymorphic_path([event.name.to_sym, record], action: event.state_machine_name.to_sym, format: nil)) # rubocop:disable Layout/LineLength
              .to params.merge(action: :trigger, id:, event: event.suffixed_name).compact
          end
        end
      end

      class_methods do
        delegate :model_class, :controller_path, to: :controller_class
        delegate :entity, to: :model_class
        delegate :events, :default, to: :entity
        alias_method :controller, :controller_path

        def controller_class
          top_level_description.constantize
        end

        def model_name
          model_class.to_s
        end

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
