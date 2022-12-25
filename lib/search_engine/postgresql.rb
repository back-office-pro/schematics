# frozen_string_literal: true

module SearchEngine
  class Postgresql
    def indexable? = false

    def concern = Schematics::Ransackable

    # :reek:ControlParameter
    # :reek:UtilityFunction
    def pagy_calendar_filter(collection, calendar_start_date, calendar_end_date, from, to)
      collection.where Schematics::Entities::Entity::CALENDAR_START =>
        (calendar_start_date || from)..(calendar_end_date || to)
    end

    def pagy_backend = :pagy
  end
end
