# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Routing # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        include Rails.application.routes.url_helpers
        fixtures :all
        delegate :entity_fixtures,
                 :model_class,
                 :controller,
                 :model_name,
                 :locale,
                 :can?,
                 :events,
                 to: :class

        let(:record) { __send__(entity_fixtures, :one) }
        let(:id) { record.id }

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
            if can?(:show) && model_class != ActiveStorage::Attachment
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
                .to route(:get, new_polymorphic_path([model_class, ::Import]))
                .to(locale:, controller: 'imports', model_name:, action: :new)
              is_expected
                .to route(:post, polymorphic_path([model_class, ::Import]))
                .to(locale:, controller: 'imports', model_name:, action: :create)
            end
            if can?(:update)
              is_expected
                .to route(:get, edit_polymorphic_path(record))
                .to(locale:, model_name:, controller:, id:, action: :edit)
              is_expected
                .to route(:patch, polymorphic_path(record))
                .to(locale:, model_name:, controller:, id:, action: :update)
              events.each do |event|
                is_expected
                  .to route(:patch, polymorphic_path(record, action: event.name))
                  .to(locale:, model_name:, controller:, action: :trigger, id:, event: event.name)
              end
            end
            if can?(:destroy) && model_class != ActiveStorage::Attachment
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
          end
        end
      end

      class_methods do
        delegate :model_class, :original_controller_path, to: :controller_class
        delegate :entity, to: :model_class
        delegate :can?, :events, to: :entity
        alias_method :controller, :original_controller_path

        def controller_class
          description.constantize
        end

        def entity_fixtures
          entity.table_name.pluralize.to_sym
        end

        def model_name
          model_class.to_s
        end

        def locale
          Rails.configuration.i18n.default_locale
        end
      end
    end
  end
end
