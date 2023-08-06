# frozen_string_literal: true

module Schematics
  module Redirectable
    extend ActiveSupport::Concern

    def redirect_to_resource_path
      return unless request.format.html?
      return if request.path.start_with?(resource_path)

      redirect_to resource_path, status: :moved_permanently
    end

    def redirect_to_edit_resource_path
      return unless request.format.html?
      return if request.path == edit_polymorphic_path(@resource)

      redirect_to edit_polymorphic_path(@resource), status: :moved_permanently
    end
  end
end
