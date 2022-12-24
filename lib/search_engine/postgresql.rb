# frozen_string_literal: true

module SearchEngine
  class Postgresql
    CALENDAR_START = Entities::Entity::CALENDAR_START

    def indexable? = false

    def concern = Schematics::Ransackable

    def pagy_calendar_filter(collection, calendar_start_date, calendar_end_date, from, to)
      collection.where CALENDAR_START => (calendar_start_date || from)..(calendar_end_date || to)
    end
  end
end
