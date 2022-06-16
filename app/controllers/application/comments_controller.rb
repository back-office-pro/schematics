# frozen_string_literal: true

module Application
  module CommentsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
      helper_method :record
    end

    def record
      parent_model_class.find(params[:id])
    end

    def resource_defaults
      return super if @resource.persisted?

      super.merge(record:)
    end
  end
end
