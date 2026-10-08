# frozen_string_literal: true

module OpenAPI
  module Components
    # :reek:Attribute
    class Header
      include ::ActiveModel::API

      attr_accessor :name, :type, :description

      def to_h = { name.to_sym => { description:, schema: } }

      private

      def schema = Type
        .new(value: type)
        .to_h
    end
  end
end
