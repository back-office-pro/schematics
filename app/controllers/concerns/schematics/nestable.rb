# frozen_string_literal: true

module Schematics
  module Nestable
    extend ActiveSupport::Concern

    included do
      helper_method :parent_model_class
      delegate :human_name, :human_name_plural, to: :parent_model_class, prefix: :parent
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
      title = t('titles.schematics.resources.index', human_name_plural: parent_human_name_plural)
      breadcrumb title, parent_model_class
    end

    def parent_model_class
      classes = Schema.instance.entities.map(&:class_name)
      constants = classes.map(&:constantize)
      classes.zip(constants).to_h.fetch(params[:model_name])
    end
  end
end
