# frozen_string_literal: true

module Schematics
  module Nestable
    extend ActiveSupport::Concern

    included do
      helper_method :parent_model_class
      helper_method :record
      delegate :human_name,
               :human_name_plural,
               to: :parent_model_class,
               prefix: :parent,
               allow_nil: true
    end

    def view_assigns = super.merge(
      parent_human_name_plural:
    )

    protected

    def parent_model_class = current_schema
      .entities
      .map { [_1.class_name, _1.model_class] }
      .to_h
      .fetch(parent_model_name)

    def parent_model_name = params[:model_name]

    def record = parent_model_class.finder(params[:"#{parent_model_class.model_name.param_key}_id"])

    def set_breadcrumb
      return unless can?(:index, parent_model_class)

      title = t('titles.schematics.resources.index', human_name_plural: parent_human_name_plural)
      breadcrumb title, parent_model_class
    end
  end
end
