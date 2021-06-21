# frozen_string_literal: true

require 'schematics/attributes/attribute'
require 'schematics/behaviours/renderable'

module Schematics
  module Attributes
    class Jsonb < Attribute
      include Behaviours::Renderable

      def default
        options[:default]&.to_json
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
