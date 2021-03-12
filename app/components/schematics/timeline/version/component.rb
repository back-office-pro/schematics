module Schematics
  module Timeline
    module Version
      class Component < ::ViewComponent::Base
        delegate :fa_icon, to: :helpers
        delegate :user, :item, :created_at, :icon, to: :@version

        def initialize(version:)
          super
          @version = version
        end
      end
    end
  end
end
