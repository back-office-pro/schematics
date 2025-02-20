# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewable
    extend ActiveSupport::Concern

    included do
      helper_method :viewers, :viewer
    end

    def viewers = {
      calendar: entity.start_date_attribute_name && entity.end_date_attribute_name,
      grid: entity.attachment_attributes.any?(&:image?),
      map: entity.address_attributes.any?,
      table: true,
      kanban: entity.enum_attributes.reject(&:readonly?).any?
    }.compact_blank.keys

    def viewer = current_user
      .preferences
      .fetch("viewer_#{entity.id}", viewers.first)
      .to_sym
  end
end
