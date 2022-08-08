# frozen_string_literal: true

module Application
  module CommentsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
    end

    def create_redirect_path = polymorphic_path(record)

    def resource_defaults = super.merge(record:)

    def update_redirect_path = polymorphic_path(record)
  end
end
