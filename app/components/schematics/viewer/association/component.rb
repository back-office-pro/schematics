# frozen_string_literal: true

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
          klass == ActiveStorage::Attachment
        end
      end
    end
  end
end
