# frozen_string_literal: true

module Schematics
  module Attributes
    class Jsonb < Attribute
      include Behaviours::Renderable
      include Behaviours::Cacheable

      def default
        options.default&.to_json
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
