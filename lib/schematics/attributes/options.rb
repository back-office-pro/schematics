# frozen_string_literal: true

module Schematics
  module Attributes
    class Options
      delegate :slice, to: :@options

      def initialize(options)
        @options = options
      end

      def method_missing(method_name)
        @options[method_name.to_s.chomp('?').to_sym]
      end

      def respond_to_missing?(method_name)
        @options.key?(method_name.to_s.chomp('?').to_sym)
      end
    end
  end
end
