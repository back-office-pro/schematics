module Schematics
  module Timeline
    module Version
      class Component < ::ViewComponent::Base
        delegate :fa_icon, to: :helpers
        delegate :user, :event, :item, :created_at, to: :@version

        def initialize(version:)
          super
          @version = version
        end

        def icon
          {
            'update' => :edit,
            'create' => :plus,
            'destroy' => :trash,
            'archive' => :archive,
            'restore' => :trash_restore,
          }[event]
        end
      end
    end
  end
end
