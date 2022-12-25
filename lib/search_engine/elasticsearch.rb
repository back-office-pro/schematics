# frozen_string_literal: true

module SearchEngine
  class Elasticsearch
    def indexable? = true

    def concern = Schematics::Elasticsearchable

    def pagy_calendar_filter(collection, calendar_start_date, calendar_end_date, from, to)
      collection.third[:where][Schematics::Entities::Entity::CALENDAR_START] = {
        gte: calendar_start_date || from,
        lte: calendar_end_date || to
      }
      collection
    end
  end
end
