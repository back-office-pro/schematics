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
        let(:id) { record.slug || record.id }

        case entity
        when Entities::Singleton
          it do
            if can?(:show)
              is_expected
                .to route(:get, polymorphic_path(model_class))
                .to(locale:, controller:, action: :show)
            end
            if can?(:update)
              is_expected
                .to route(:get, edit_polymorphic_path(model_class))
                .to(locale:, controller:, action: :edit)
              is_expected
                .to route(:patch, polymorphic_path(model_class))
                .to(locale:, controller:, action: :update)
            end
          end
        else
          it do
            if can?(:index)
              is_expected
                .to route(:get, polymorphic_path(model_class))
                .to(locale:, model_name:, controller:, action: :index)
              is_expected
                .to route(:get, polymorphic_path(model_class, action: :autocomplete))
                .to(locale:, model_name:, controller:, action: :autocomplete)
            end
            if can?(:show) && model_class != ::ActiveStorage::Attachment
              is_expected
                .to route(:get, polymorphic_path(record))
                .to(locale:, model_name:, controller:, action: :show, id:)
            end
            if can?(:create)
              is_expected
                .to route(:get, new_polymorphic_path(model_class))
                .to(locale:, model_name:, controller:, action: :new)
              is_expected
                .to route(:post, polymorphic_path(model_class))
                .to(locale:, model_name:, controller:, action: :create)
              is_expected
                .to route(:post, polymorphic_path(record, action: :duplicate))
                .to(locale:, controller:, model_name:, id:, action: :duplicate)
              is_expected
                .to route(:get, new_polymorphic_path([model_class, ::Import], format: nil))
                .to(locale:, controller: 'imports', model_name:, action: :new)
              is_expected
                .to route(:post, polymorphic_path([model_class, ::Import], format: nil))
                .to(locale:, controller: 'imports', model_name:, action: :create)
            end
            if can?(:update)
              is_expected
                .to route(:get, edit_polymorphic_path(record))
                .to(locale:, model_name:, controller:, id:, action: :edit)
              is_expected
                .to route(:patch, polymorphic_path(record))
                .to(locale:, model_name:, controller:, id:, action: :update)
            end
            if can?(:destroy) && model_class != ::ActiveStorage::Attachment
              is_expected
                .to route(:delete, polymorphic_path(record))
                .to(locale:, model_name:, controller:, id:, action: :destroy)
              is_expected
                .to route(:get, polymorphic_path(record, action: :delete))
                .to(locale:, model_name:, controller:, id:, action: :delete)
            end
            if can?(:archive)
              is_expected
                .to route(:delete, polymorphic_path(record, action: :archive))
                .to(locale:, model_name:, controller:, id:, action: :archive)
              is_expected
                .to route(:delete, polymorphic_path(record, action: :restore))
                .to(locale:, model_name:, controller:, id:, action: :restore)
            end
            events.each do |event|
              is_expected
                .to route(:patch, polymorphic_path(record, action: event.name))
                .to(locale:, model_name:, controller:, action: :trigger, id:, event: event.name)
            end
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
