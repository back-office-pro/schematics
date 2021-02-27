module Schematics
  module Timeline
    class Component < ::ViewComponent::Base
      delegate :fa_icon, to: :helpers

      def initialize(versions:)
        super
        @versions = versions
      end
    end
  end
end
