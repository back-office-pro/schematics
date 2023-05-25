# frozen_string_literal: true

module Schematics
  module Attributes
    class Integer < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable
      include Behaviours::Numerable
      include Behaviours::Incrementable

      def available_options = super.push(Options::Unit)

      def database_type = 'integer'

      def default = 1

      def open_api_type = ::Integer

      def precision = 0

      def validators = super.merge(
        numericality: { only_integer: true }
      )
    end
  end
end
