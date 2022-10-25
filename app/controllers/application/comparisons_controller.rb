# frozen_string_literal: true

module Application
  module ComparisonsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
      skip_before_action :set_breadcrumb, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
      before_action :set_resources, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter
    end

    protected

    def i18n_title_path = 'comparisons'

    def parent_model_class = @resource
      .model
      .try(:safe_constantize)

    def set_resources
      @resources = parent_model_class
                   .preload(parent_model_class.entity.includes)
                   .where(id: @resource.ids)
                   .accessible_by(current_ability)
                   .load_async
    end
  end
end
