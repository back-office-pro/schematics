# frozen_string_literal: true

module Schematics
  module Attributes
    class Boolean < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def icon = :toggle_on

      def open_api_type = 'boolean'

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
