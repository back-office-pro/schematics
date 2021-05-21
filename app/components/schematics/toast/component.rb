# frozen_string_literal: true

module Schematics
  module Toast
    class Component < ApplicationComponent
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
