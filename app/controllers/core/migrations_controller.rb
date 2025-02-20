# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class MigrationsController < Schematics::ResourcesController
  rate_limit to: 3, within: 1.minute, only: %i[create update]

  def new
    super && edit
  end

  def edit
    @resource.prompt ||= model_class.default_prompt
  end

  private

  def permitted_params = super << {
    entities_attributes: [
      [
        :id,
        :name,
        [options_attributes: [:icon, :descriptor, [actions: []]]],
        [attributes_attributes: [[:id, :name, :type, { options_attributes: {} }]]],
        [virtuals_attributes: [[:id, :name, :function, { options_attributes: {} }]]],
        [has_and_belongs_to_many_associations_attributes: [[:name, :type, { options_attributes: {} }]]], # rubocop:disable Layout/LineLength
        [triggers_attributes: [%i[id action callback]]]
      ]
    ]
  }

  def resource_params
    return super if super.key?(permitted_params.first)

    Core::MigrationMapper.new.call(super.to_h)
  end
end
