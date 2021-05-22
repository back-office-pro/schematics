# frozen_string_literal: true

require 'schematics/attributes/attribute'

module Schematics
  module Attributes
    class Jsonb < Attribute
      def default
        options[:default]&.to_json
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
