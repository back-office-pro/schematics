# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ComparisonsController < Schematics::ResourcesController
  include Schematics::Nestable

  before_action :set_resources, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action -> { authorize!(:show, parent_model_class) }, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter

  protected

  def model_name = 'Comparison'

  def parent_model_name
    @resource.try(:model) || super
  end

  def resource_defaults
    super.merge(model: parent_model_class.to_s)
  end

  def set_resources
    @resources = parent_model_class
                 .preload_all
                 .where(id: @resource.ids)
                 .accessible_by(current_ability)
                 .load_async
  end
end
