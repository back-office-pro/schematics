# frozen_string_literal: true

module Schematics
  module EmptyResource
    class Component < ApplicationComponent
      def title = t('.title')
    end
  end
end
