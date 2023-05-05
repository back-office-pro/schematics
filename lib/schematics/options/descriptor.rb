# frozen_string_literal: true

module Schematics
  module Options
    # :reek:Attribute
    class Descriptor < Option
      include ::ActiveModel::API

      attr_accessor :collection

      def multiple? = false

      def input_type = :select

      def controller = 'schema-editor--descriptor-dropdown'
    end
  end
end
