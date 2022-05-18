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

      def open_api_type = ::Integer

      def validators = super.merge(
        numericality: { only_integer: true }
      )

      protected

      def migration_options = super.push(
        :limit
      )
    end
  end
end
