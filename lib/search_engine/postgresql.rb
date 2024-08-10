# frozen_string_literal: true

module SearchEngine
  # :reek:MissingSafeMethod
  class Postgresql
    def indexable? = false

    def concern = Schematics::Ransackable

    # :reek:ControlParameter
    # :reek:UtilityFunction
    def pagy_calendar_filter(collection, start_date_attribute_name, gte, lte)
      collection.where start_date_attribute_name => gte..lte
    end

    def pagy_backend = :pagy

    def backend_mode = :async

    def multisearch = Core::Searches::Ransack

    def initialize! = nil
  end
end
