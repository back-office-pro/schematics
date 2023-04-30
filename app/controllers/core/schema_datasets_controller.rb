# frozen_string_literal: true

class SchemaDatasetsController < Schematics::ResourcesController
  private

  def permitted_params
    {
      entities_attributes: [
        :id,
        :name,
        [options_attributes: [:icon, :descriptor, [actions: []], :hidden]],
        [attributes_attributes: [:id, :name, :type, [options_attributes: {}]]],
        [virtuals_attributes: [:name, :function, [options_attributes: {}]]],
        [triggers_attributes: %i[action callback]],
        [has_and_belongs_to_many_associations_attributes: %i[name type]]
      ]
    }
  end

  def resource_params = Core::SchemaDatasetMapper
    .new
    .call(super.to_h)
end
