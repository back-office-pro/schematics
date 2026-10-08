# frozen_string_literal: true

Ransack.configure do |config|
  config.search_key = :filter
  config.add_predicate 'gte', arel_predicate: 'gteq'
  config.add_predicate 'lte', arel_predicate: 'lteq'
  config.add_predicate 'any', arel_predicate: 'any', case_insensitive: true
end
