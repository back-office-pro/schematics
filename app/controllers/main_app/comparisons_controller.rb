# frozen_string_literal: true

module MainApp
  module ComparisonsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
      skip_authorize_resource only: %i[show new create]
      skip_before_action :set_breadcrumb, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
      before_action -> { authorize!(:show, parent_model_class) }, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter
      before_action :set_resources, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter
    end

    protected

    def set_resources
      @resources = parent_model_class
                   .includes(parent_model_class.entity.includes)
                   .includes(:slugs)
                   .where(id: @resource.ids)
                   .accessible_by(current_ability)
    end

    def parent_model_class
      @resource.model.try(:safe_constantize)
    end
  end
end
