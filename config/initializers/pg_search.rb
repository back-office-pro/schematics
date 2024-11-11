# frozen_string_literal: true

require 'pg_search'

PgSearch.multisearch_options = {
  using: { tsearch: { prefix: true, any_word: true } },
  ignoring: :accents
}
