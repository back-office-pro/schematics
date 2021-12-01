# frozen_string_literal: true

module Schematics
  module Calendarable
    extend ActiveSupport::Concern

    included do
      helper_method :calendar_start_attribute,
                    :calendar_end_attribute,
                    :calendar_start_date,
                    :calender_end_date
    end

    def pagy_calendar_period(*)
      [
        calendar_start_date ||
          model_class.with_deleted.minimum(calendar_start_attribute) ||
          Date.current.beginning_of_month,
        calendar_end_date ||
          model_class.with_deleted.maximum(calendar_end_attribute) ||
          Date.current.end_of_month
      ].map(&:in_time_zone).map(&:to_time)
    end

    def pagy_calendar_filter(collection, from, to)
      collection.third[:where][calendar_start_attribute] = {
        gte: calendar_start_date || from.to_date,
        lte: calendar_end_date || to.to_date
      }
      collection
    end

    private

    def calendar_start_date
      params.dig(:filter, calendar_start_attribute, :gte)&.to_date
    end

    def calendar_end_date
      params.dig(:filter, calendar_end_attribute, :lte)&.to_date
    end

    def calendar_start_attribute
      entity.datetime_attributes.first.name.to_sym # FIXME: could work randomly
    end

    def calendar_end_attribute
      entity.datetime_attributes.second.name.to_sym # FIXME: could work randomly
    end
  end
end
