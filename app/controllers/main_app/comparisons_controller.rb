# frozen_string_literal: true

module MainApp
  module ComparisonsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
      before_action :set_resources, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter
    end

    protected

    def set_resources
      @resources = parent_model_class
                   .where(id: @resource.ids)
                   .accessible_by(current_ability)
    end

    def parent_model_class
      @resource.model.constantize
    end
  end
end
