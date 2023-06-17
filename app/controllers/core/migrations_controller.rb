# frozen_string_literal: true

class MigrationsController < Schematics::ResourcesController
  private

  def permitted_params = {
    entities_attributes: [
      :id,
      :name,
      [options_attributes: [:icon, :descriptor, [actions: []]]],
      [attributes_attributes: [:id, :name, :type, [options_attributes: {}]]],
      [virtuals_attributes: [:id, :name, :function, [options_attributes: {}]]],
      [has_and_belongs_to_many_associations_attributes: [:name, :type, [options_attributes: {}]]],
      [triggers_attributes: %i[action callback]]
    ]
  }

  def resource_params = Core::MigrationMapper
    .new
    .call(super.to_h)
end
