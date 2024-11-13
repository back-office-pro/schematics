# frozen_string_literal: true

require 'pg_search'

PgSearch.unaccent_function = 'immutable_unaccent'
PgSearch.multisearch_options = {
  using: { tsearch: { prefix: true, any_word: true } },
  ignoring: :accents
}
