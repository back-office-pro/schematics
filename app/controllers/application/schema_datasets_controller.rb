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

    def resource_params = Application::SchemaDatasetMapper
      .new
      .call(super.to_h)
  end
end
