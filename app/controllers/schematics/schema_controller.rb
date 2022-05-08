# frozen_string_literal: true

module Schematics
  class SchemaController < ApplicationController
    authorize_resource

    def edit; end

    def update
      data = params[:schema].to_unsafe_h.deep_symbolize_keys
      formatted_data = {
        entities: data[:entities_attributes].values.map do |entity|
          {
            name: entity[:name],
            options: entity[:options],
            attributes: entity[:attributes_attributes].values,
            virtuals: entity[:virtuals_attributes]&.values,
            triggers: entity[:triggers_attributes]&.values
          }.compact
        end
      }
      Rails.logger.debug formatted_data.inspect
      Schematics::Schema.instance.entities = formatted_data[:entities]
      Rails.logger.debug Schematics::Schema.instance.valid?
      Rails.logger.debug Schematics::Schema.instance.errors.inspect
      ::Singleton.__init__(Schematics::Schema)
    end
  end
end
