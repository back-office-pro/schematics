# frozen_string_literal: true

module Schematics
  module DeleteAlert
    class Component < ApplicationComponent
      def title = t('.title')

      def text = t('.text')

      def icon = :triangle_exclamation
    end
  end
end
