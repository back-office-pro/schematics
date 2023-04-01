# frozen_string_literal: true

module Schematics
  module Redirectable
    extend ActiveSupport::Concern

    def redirect_to_resource_path
      return if request.path.start_with? polymorphic_path(@resource)

      redirect_to polymorphic_path(@resource), status: :moved_permanently
    end

    def redirect_to_edit_resource_path
      return if request.path == edit_polymorphic_path(@resource)

      redirect_to edit_polymorphic_path(@resource), status: :moved_permanently
    end
  end
end
