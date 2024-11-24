# frozen_string_literal: true

module Schematics
  module Attributes
    class Boolean < Attribute
      include Behaviours::Migratable
      include Behaviours::Indexable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def default = false

      def icon = :toggle_on

      def open_api_type = 'boolean'

      def search_predicate = :eq

      def format(value)
        translate(value, default: value.to_s).upcase
      end

      def validators
        super.rename_keys(presence: :acceptance)
      end
    end
  end
end
