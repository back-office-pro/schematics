# frozen_string_literal: true

module Schematics
  module Behaviours
    module Fillable
      delegate :default, :readonly?, to: :options

      def permitted_params
        column_name.to_sym
      end

      def permitted_json_params
        permitted_params
      end

      def json_default
        default
      end

      def to_str
        return super unless readonly?

        <<~RUBY
          attr_readonly :#{name}
        RUBY
      end
    end
  end
end
