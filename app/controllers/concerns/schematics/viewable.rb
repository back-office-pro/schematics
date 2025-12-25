# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
