# frozen_string_literal: true

module SearchEngine
  # :reek:MissingSafeMethod
  class Opensearch
    def indexable? = true

    def concern = Schematics::Searchkickable

    # :reek:ControlParameter
    # :reek:UtilityFunction
    def pagy_calendar_filter(collection, start_date_attribute_name, gte, lte)
      collection.tap { _1.third[:where][start_date_attribute_name] = { gte:, lte: } }
    end

    def pagy_backend = :pagy_searchkick

    def multisearch = Core::Searches::Searchkick

    # :reek:UtilityFunction
    def initialize!
      ::Rails.application.eager_load!
      ::Searchkick.models.each(&:reindex)
    end
  end
end
