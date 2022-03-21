# frozen_string_literal: true

module Schematics
  module Nestable
    extend ActiveSupport::Concern

    included do
      helper_method :parent_model_class
      delegate :human_name,
               :human_name_plural,
               to: :parent_model_class,
               prefix: :parent,
               allow_nil: true
    end

    class_methods do
      def controller_path
        File.join('schematics', controller_name)
      end
    end

    def view_assigns
      super.merge(parent_human_name_plural:)
    end

    protected

    def set_breadcrumb
      return unless can?(:index, parent_model_class)

      title = t('titles.schematics.resources.index', human_name_plural: parent_human_name_plural)
      breadcrumb title, parent_model_class
    end

    def parent_model_class
      Schema
        .instance
        .entities
        .map { [_1.class_name, _1.model_class] }
        .to_h
        .fetch(params[:model_name])
    end
  end
end
