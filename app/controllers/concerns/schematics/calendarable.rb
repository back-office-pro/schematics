# frozen_string_literal: true

module Schematics
  module Calendarable
    extend ActiveSupport::Concern

    CALENDAR_START = Entities::Entity::CALENDAR_START
    CALENDAR_END = Entities::Entity::CALENDAR_END

    def pagy_calendar_filter(collection, from, to)
      collection.third[:where][CALENDAR_START] = {
        gte: calendar_start_date || from,
        lte: calendar_end_date || to
      }
      collection
    end

    def pagy_calendar_period(*)
      [
        calendar_start_date ||
          model_class.with_deleted.minimum(CALENDAR_START) ||
          ::Time.current.beginning_of_month,
        calendar_end_date ||
          model_class.with_deleted.maximum(CALENDAR_END) ||
          ::Time.current.end_of_month
      ]
    end

    private

    def calendar_end_date = params
      .dig(:filter, CALENDAR_END, :lte)
      &.in_time_zone

    def calendar_start_date = params
      .dig(:filter, CALENDAR_START, :gte)
      &.in_time_zone
  end
end
