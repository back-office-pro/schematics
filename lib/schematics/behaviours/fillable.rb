# frozen_string_literal: true

module Schematics
  module Behaviours
    module Fillable
      delegate :readonly?, to: :options

      def available_options = super.push(
        Options::Default,
        Options::Readonly
      )

      def json_default = default

      def permitted_json_params = permitted_params

      def permitted_params = column_name.to_sym

      def to_str
        return super unless options.default

        super + <<~RUBY
          attribute :#{name}, default: -> { #{options.default.to_json} }
        RUBY
      end
    end
  end
end
