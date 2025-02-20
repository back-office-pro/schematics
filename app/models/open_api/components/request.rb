# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Components
    # :reek:Attribute
    class Request
      include ::ActiveModel::API
      attr_accessor :entity

      delegate :fillable_elements, :open_api_body, to: :entity, private: true

      def to_h = {
        required: false,
        description: '',
        content: {
          'multipart/form-data': {
            schema: {
              type: 'object',
              properties: fillable_elements
                .grep_v(Schematics::Attributes::User)
                .grep_v(Schematics::Associations::HasManyNested)
                .map do |element|
                  {
                    element.input_name.to_sym => Type
                      .new(value: element.open_api_body_type)
                      .to_h
                      .merge(default: element.options.default, required: element.required?)
                      .compact
                  }
                end.reduce(&:merge)
            }
          },
          'application/json': {
            schema: Type
              .new(value: open_api_body)
              .to_h
          }
        }
      }
    end
  end
end
