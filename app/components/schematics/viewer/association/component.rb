module Schematics
  module Viewer
    module Association
      class Component < Viewer::Component
        delegate :confirm_data, to: :helpers

        def initialize(resources:, collapsed: false)
          super(resources: resources)
          @collapsed = collapsed
        end

        def title
          klass.human_attribute_name(entity.name, count: @resources.size)
        end

        def random
          @random ||= SecureRandom.base58
        end

        def collapsed?
          @collapsed
        end

        def attachment?
          klass.try(:entity)
        end

        def klass
          @resources.first.class
        end

        def entity
          klass.try(:entity) || Entities::Entity.active_storage_attachment(
            name: @resources.first.name,
            icon: @resources
              .first
              .record
              .class
              .entity
              .find_field_by_name(@resources.first.name)
              .icon
          )
        end
      end
    end
  end
end
