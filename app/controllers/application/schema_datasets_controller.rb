# frozen_string_literal: true

module Application
  module SchemaDatasetsController
    extend ActiveSupport::Concern

    def permitted_params
      {
        entities_attributes: [
          :name,
          [options: [:icon, :descriptor, [actions: []], :hidden]],
          [attributes_attributes: [:name, :type, [options: {}]]],
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
        .map do |name:, options:, attributes_attributes:, virtuals_attributes: [], triggers_attributes: []| # rubocop:disable Layout/LineLength
          {
            name:,
            options:,
            attributes: attributes_attributes.values.map do |attribute|
              {
                name: attribute[:name],
                type: attribute[:type],
                options: attribute[:options].compact_blank
              }
            end,
            virtuals: virtuals_attributes.values,
            triggers: triggers_attributes.values
          }.compact
        end
    }
  end
end
