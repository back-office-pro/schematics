# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Translation
    extend ActiveSupport::Concern

    prepended do
      scope :lookup, Translations::LookupQuery
    end

    def cache_key = [model_name.plural, locale, key].join('/')
  end
end
