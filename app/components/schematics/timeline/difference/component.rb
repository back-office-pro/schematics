module Schematics
  module Timeline
    module Difference
      class Component < ::ViewComponent::Base
        delegate :fa_icon, to: :helpers
        delegate :id, :entity, :item_class, :reify, to: :@version

        def initialize(version:)
          @version = version
        end

        def new_version
          @version.next&.reify || reify
        end
      end
    end
  end
end
