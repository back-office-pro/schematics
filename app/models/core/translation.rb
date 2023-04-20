# frozen_string_literal: true

module Core
  module Translation
    extend ActiveSupport::Concern

    prepended do
      scope :lookup, LookupQuery
    end

    def cache_key = [model_name.plural, locale, key].join('/')
  end
end
