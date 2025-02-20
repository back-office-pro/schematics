# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Redirectable
    extend ActiveSupport::Concern

    def redirect_to_resource_path
      return unless request.format.html?
      return if request.path.start_with?(show_path)

      redirect_to show_path, status: :moved_permanently
    end

    def redirect_to_edit_resource_path
      return unless request.format.html?
      return if request.path == edit_resource_path(@resource)

      redirect_to edit_resource_path(@resource), status: :moved_permanently
    end
  end
end
