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
  module Calendarable
    extend ActiveSupport::Concern

    delegate :entity, to: :model_class, private: true
    delegate :start_date_attribute_name,
             :end_date_attribute_name,
             to: :entity,
             private: true

    def pagy_calendar_filter(collection, from, to)
      collection.where(
        start_date_attribute_name => (calendar_start_date || from)..(calendar_end_date || to)
      )
    end

    def pagy_calendar_period(*)
      [
        calendar_start_date ||
          model_class.with_deleted.minimum(start_date_attribute_name) ||
          ::Time.current.beginning_of_month,
        calendar_end_date ||
          model_class.with_deleted.maximum(end_date_attribute_name) ||
          ::Time.current.end_of_month
      ]
    end

    private

    def calendar_start_date = params
      .dig(filter_key, start_date_attribute_name, :gte)
      &.in_time_zone

    def filter_key = Ransack.options[:search_key]

    def calendar_end_date = params
      .dig(filter_key, end_date_attribute_name, :lte)
      &.in_time_zone
  end
end
