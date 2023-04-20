# frozen_string_literal: true

module Schematics
  module Head
    class Component < ApplicationComponent
      delegate :title, to: :helpers

      def theme_color = config(:theme_color)

      def company_name = config(:company_name)
    end
  end
end
