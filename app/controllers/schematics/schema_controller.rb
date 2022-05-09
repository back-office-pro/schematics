# frozen_string_literal: true

module Schematics
  class SchemaController < ApplicationController
    authorize_resource

    def edit; end

    def update
      entities = schema_params
                 .to_unsafe_h
                 .deep_symbolize_keys[:entities_attributes]
                 .values
                 .map do |entity|
                   {
                     name: entity[:name],
                     options: entity[:options],
                     attributes: entity[:attributes_attributes].values,
                     virtuals: entity[:virtuals_attributes]&.values,
                     triggers: entity[:triggers_attributes]&.values
                   }.compact
                 end
      Schematics::Schema.instance.assign_attributes(entities:)
      Rails.logger.debug entities.inspect
      Rails.logger.debug Schematics::Schema.instance.valid?
      Rails.logger.debug Schematics::Schema.instance.errors.inspect
      ::Singleton.__init__(Schematics::Schema)
    end

    private

    def schema_params
      params
        .require(:schema)
        .permit(
          entities_attributes: [
            :name,
            [options: [:icon, :descriptor, [actions: []], :hidden]],
            [attributes_attributes: [:name, :type, [options: {}]]],
            [virtuals_attributes: [:name, :function, [options: {}]]],
            [triggers_attributes: %i[action callback]]
          ]
        )
    end
  end
end
