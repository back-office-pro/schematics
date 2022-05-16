# frozen_string_literal: true

module Schematics
  module Attributes
    class Boolean < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def open_api_type = 'boolean'
      def icon = :toggle_on

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
