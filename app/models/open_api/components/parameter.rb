# frozen_string_literal: true

module OpenAPI
  module Components
    # :reek:Attribute
    class Parameter
      include ::ActiveModel::API

      attr_accessor :name, :in, :type, :description

      class << self
        def id = new(name: 'id', in: 'path', type: 'string')
      end

      def to_h = { name:, in:, required: false, schema:, description: }.compact

      private

      def schema = Type
        .new(value: type)
        .to_h
        .merge(description:)
        .compact
    end
  end
end
