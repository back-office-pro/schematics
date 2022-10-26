# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Routing # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      UPDATE_DENYLIST = [::Comment].freeze
      SHOW_DENYLIST = [::ActiveStorage::Attachment].freeze
      DESTROY_DENYLIST = [::ActiveStorage::Attachment].freeze

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
        let(:id) { (record.slug || record.id) unless record.is_a?(::Singleton) }
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
          end
          if can?(:show) && SHOW_DENYLIST.exclude?(model_class)
            is_expected
              .to route(:get, polymorphic_path(record))
              .to params.merge(action: :show, id:).compact
            is_expected
              .to route(:get, new_polymorphic_path([record, ::Comment], format: nil))
              .to params.merge(controller: 'comments', parent_id => id, action: :new).compact
            is_expected
              .to route(:post, polymorphic_path([record, ::Comment], format: nil))
              .to params.merge(controller: 'comments', parent_id => id, action: :create).compact
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
              .to params.merge(controller: 'imports', action: :new)
            is_expected
              .to route(:post, polymorphic_path([model_class, ::Import], format: nil))
              .to params.merge(controller: 'imports', action: :create)
          end
          if can?(:update) && UPDATE_DENYLIST.exclude?(model_class)
            is_expected
              .to route(:get, edit_polymorphic_path(record))
              .to params.merge(id:, action: :edit).compact
            is_expected
              .to route(:patch, polymorphic_path(record))
              .to params.merge(id:, action: :update).compact
          end
          if can?(:destroy) && DESTROY_DENYLIST.exclude?(model_class)
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
          end
          events.each do |event|
            is_expected
              .to route(:patch, polymorphic_path(record, action: event.name))
              .to params.merge(action: :trigger, id:, event: event.name)
          end
        end
      end

      class_methods do
        delegate :model_class, :controller_path, to: :controller_class
        delegate :entity, to: :model_class
        delegate :can?, :events, :default, to: :entity
        alias_method :controller, :controller_path

        def controller_class
          description.constantize
        end

        def model_name
          model_class.to_s
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
