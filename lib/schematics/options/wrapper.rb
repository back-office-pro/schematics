# frozen_string_literal: true

module Schematics
  module Options
    # :reek:Attribute :reek:InstanceVariableAssumption
    class Wrapper
      include ::ActiveModel::API

      delegate :slice,
               :fetch,
               :dig,
               :key?,
               :keys,
               :merge!,
               :include?,
               :each,
               :delete,
               to: :options

      attr_writer :options

      def method_missing(method_name, *, &)
        return dig(method_name) unless method_name.end_with?('?')

        fetch(method_name.to_s.chomp('?').to_sym, false)
      end

      def respond_to_missing?(method_name, *)
        key?(method_name.to_s.chomp('?').to_sym)
      end

      def options = @options || {}
    end
  end
end
