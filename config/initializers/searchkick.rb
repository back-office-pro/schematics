# frozen_string_literal: true

Searchkick.timeout = 10
Searchkick.search_timeout = 3
Searchkick
  .models
  .each(&:reindex_async)
