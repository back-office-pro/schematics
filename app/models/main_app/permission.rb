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
    end
  end
end
