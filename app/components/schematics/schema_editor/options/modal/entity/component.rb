# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Modal
        module Entity
          class Component < Modal::Component
            delegate :default_actions, :actions, :icon, :descriptor, to: 'builder.object'
            delegate :allowed_field_names, to: :descriptor

            def actions_collection = default_actions
              .map { [t(_1, scope: %i[activerecord attributes permission actions]), _1] }
              .sort
          end
        end
      end
    end
  end
end
