# frozen_string_literal: true

module Schematics
  module CardHeading
    class Component < ApplicationComponent
      def initialize(icon:, title:)
        super
        @icon = icon
        @title = title
      end
    end
  end
end
