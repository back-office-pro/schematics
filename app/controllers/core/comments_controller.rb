# frozen_string_literal: true

module Core
  module CommentsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
    end

    def resource_path = polymorphic_path(record, comments: '').chop

    def parent_model_name
      @resource.try(:record_type) || super
    end

    def record
      @resource.try(:record) || super
    end

    def resource_defaults = super.merge(record:)
  end
end
