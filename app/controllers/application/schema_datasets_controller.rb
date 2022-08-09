# frozen_string_literal: true

module Application
  module SchemaDatasetsController
    extend ActiveSupport::Concern

    def permitted_params
      {
        entities_attributes: [
          :id,
          :name,
          [options_attributes: [:icon, :descriptor, [actions: []], :hidden]],
          [attributes_attributes: [:id, :name, :type, [options_attributes: {}]]],
          [virtuals_attributes: [:name, :function, [options_attributes: {}]]],
          [triggers_attributes: %i[action callback]]
        ]
      }
    end

    def resource_params = { # rubocop:disable Metrics/CyclomaticComplexity
      data: super
        .to_h
        .deep_symbolize_keys[:entities_attributes]
        .values
        .map do |entity|
          {
            id: entity[:id],
            name: entity[:name],
            options: entity[:options_attributes],
            attributes: entity[:attributes_attributes].values.map do |attribute|
              {
                id: attribute[:id],
                name: attribute[:name],
                type: attribute[:type],
                options: attribute[:options_attributes].compact_blank
              }
            end,
            virtuals: entity[:virtuals_attributes]&.values&.map do |virtual|
              {
                name: virtual[:name],
                function: virtual[:function],
                options: virtual[:options_attributes]&.compact_blank
              }
            end,
            triggers: entity[:triggers_attributes]&.values
          }.compact
        end
    }
  end
end
