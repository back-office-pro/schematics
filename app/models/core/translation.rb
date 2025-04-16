# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::Translation < Schematics::ApplicationRecord
  scope :lookup, ::Core::Translations::LookupQuery

  def cache_key = [model_name.plural, locale, key].join('/')
end
