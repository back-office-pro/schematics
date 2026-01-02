# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Filterable
    extend ActiveSupport::Concern

    def log_search!
      current_user.log_search!(model_class.to_s, filter_params)
    end

    def filter_params
      return {} unless params.key?(filter_key)

      params
        .expect(filter_key => permitted_filters)
        .to_h
        .compact_blank
        .deep_symbolize_keys
    end

    private

    def filter_key = Ransack.options[:search_key]

    def permitted_filters = entity
      .searchable_elements
      .grep_v(Schematics::Behaviours::Rangeable)
      .map(&:name)
      .map(&:to_sym)
      .push(:with_deleted)
      .concat(entity.rangeable_elements.map { { _1.name.to_sym => %i[gte lte] } })
  end
end
