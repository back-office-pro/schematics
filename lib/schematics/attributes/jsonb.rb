# frozen_string_literal: true

module Schematics
  module Attributes
    class Jsonb < Attribute
      include Behaviours::Fillable
      include Behaviours::Renderable
      delegate :default, to: :options

      def open_api_type = {}
      def icon = :table

      def permitted_params
        { super => {} }
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
