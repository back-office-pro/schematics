# frozen_string_literal: true

module Schematics
  module Calendarable
    extend ActiveSupport::Concern

    CALENDAR_START = Entities::Entity::CALENDAR_START
    CALENDAR_END = Entities::Entity::CALENDAR_END

    def pagy_calendar_filter(collection, from, to)
      collection.third[:where][CALENDAR_START] = {
        gte: calendar_start_date || from.to_date,
        lte: calendar_end_date || to.to_date
      }
      collection
    end

    def pagy_calendar_period(*)
      [
        calendar_start_date ||
          model_class.with_deleted.minimum(CALENDAR_START) ||
          ::Date.current.beginning_of_month,
        calendar_end_date ||
          model_class.with_deleted.maximum(CALENDAR_END) ||
          ::Date.current.end_of_month
      ].map(&:in_time_zone).map(&:to_time)
    end

    private

    def calendar_end_date = params
      .dig(:filter, CALENDAR_END, :lte)
      &.to_date

    def calendar_start_date = params
      .dig(:filter, CALENDAR_START, :gte)
      &.to_date
  end
end
