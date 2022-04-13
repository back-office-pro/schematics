# frozen_string_literal: true

module Schematics
  module Attributes
    class Jsonb < Attribute
      include Behaviours::Fillable
      include Behaviours::Renderable
      delegate :default, to: :options

      def open_api_type
        {}
      end

      def permitted_params
        { super => {} }
      end

      def icon
        :table
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
