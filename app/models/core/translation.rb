# frozen_string_literal: true

module Core
  class Translation < Schematics::ApplicationRecord
    scope :lookup, Translations::LookupQuery

    def cache_key = [model_name.plural, locale, key].join('/')
  end
end
