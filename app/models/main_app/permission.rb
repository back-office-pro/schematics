# frozen_string_literal: true

module MainApp
  module Permission
    extend ActiveSupport::Concern

    ACTIONS = %w[index show create update import destroy archive].freeze

    class_methods do
      def create_entity_permissions!(entity)
        ACTIONS
          .select(&entity.method(:can?))
          .concat(entity.events.map(&:name))
          .each do |action|
            ::Role
              .admin
              .permissions
              .push(create!(model: entity.class_name, action:))
          end
      end

      def destroy_entity_permissions(model)
        destroy_all(model:)
        ::Chart.destroy_all(model:)
        ::Stat.destroy_all(model:)
        ::Schematics::Version.destroy_all(item_type: model)
      end

      def rename_entity_permissions(model, new_model)
        # rubocop:disable Rails/SkipsModelValidations
        where(model:).update_all(model: new_model)
        ::Chart.where(model:).update_all(model: new_model)
        ::Stat.where(model:).update_all(model: new_model)
        ::Schematics::Version.where(item_type: model).update_all(model: new_model)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
