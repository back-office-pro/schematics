module Schematics
  module Toast
    class Component < ::ViewComponent::Base
      delegate :fa_icon, to: :helpers
      delegate :first, :second, to: :@flash
      alias type first
      alias message second

      def initialize(flash:)
        super
        @flash = flash
      end

      def css_class
        { 'notice' => 'success', 'alert' => 'danger' }[type]
      end
    end
  end
end
