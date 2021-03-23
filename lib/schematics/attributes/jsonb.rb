require 'schematics/attributes/attribute'

module Schematics
  module Attributes
    class Jsonb < Attribute
      def default
        options[:default]&.to_json
      end

      def to_str
        return super unless options.key?(:default)
        <<~RUBY
          store :#{name}, accessors: #{options[:default].keys}, prefix: true
        RUBY
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
