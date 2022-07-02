# frozen_string_literal: true

module Application
  module SchemaDatasetsController
    extend ActiveSupport::Concern

    def permitted_params
      {
        entities_attributes: [
          :id,
          :name,
          [options: [:icon, :descriptor, [actions: []], :hidden]],
          [attributes_attributes: [:id, :name, :type, [options: {}]]],
          [virtuals_attributes: [:name, :function, [options: {}]]],
          [triggers_attributes: %i[action callback]]
        ]
      }
    end

    def resource_params = {
      data: super
        .to_h
        .deep_symbolize_keys[:entities_attributes]
        .values
        .map do |entity|
          {
            id: entity[:id],
            name: entity[:name],
            options: entity[:options],
            attributes: entity[:attributes_attributes].values.map do |attribute|
              {
                id: attribute[:id],
                name: attribute[:name],
                type: attribute[:type],
                options: attribute[:options].compact_blank
              }
            end,
            virtuals: entity[:virtuals_attributes]&.values,
            triggers: entity[:triggers_attributes]&.values
          }.compact
        end
    }
  end
end
