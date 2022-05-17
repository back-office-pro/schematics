# frozen_string_literal: true

module MainApp
  module SchemaDatasetsController
    extend ActiveSupport::Concern

    def create
      data = resource_params
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
      Schematics::Schema.instance.load(data:)
      Rails.logger.debug data.inspect
      Rails.logger.debug Schematics::Schema.instance.valid?
      Rails.logger.debug Schematics::Schema.instance.errors.inspect
      Schematics::Schema.instance.load(data: ::SchemaDataset.current.data)
    end

    private

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
  end
end
