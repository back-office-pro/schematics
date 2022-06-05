# frozen_string_literal: true

module Schematics
  module Attributes
    class Float < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable
      include Behaviours::Numerable

      def available_options = super.push(
        :unit,
        :precision
      )

      def database_type = 'float'

      def default = 1.5

      def open_api_type = ::Float
    end
  end
end
