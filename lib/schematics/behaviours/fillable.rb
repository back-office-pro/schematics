# frozen_string_literal: true

module Schematics
  module Behaviours
    module Fillable
      delegate :group, :readonly?, to: :options

      def available_options = super.push(
        Options::Group,
        Options::Default,
        Options::Readonly
      )

      def json_default = default

      def permitted_json_params = permitted_params

      def permitted_params = column_name.to_sym

      def input_name(source_entity = entity)
        "#{source_entity.table_name}[#{column_name}]"
      end

      def open_api_body_type = open_api_schema_type

      def to_open_api_body = [:"#{column_name}#{'!' if required?}", open_api_body_type]

      def to_str
        return super unless options.default

        super + <<~RUBY
          attribute :#{name}, default: -> { #{options.default.to_json} }
        RUBY
      end
    end
  end
end
