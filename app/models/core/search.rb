# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::Search < Schematics::ApplicationRecord
  scope :history, ::Core::Searches::HistoryQuery
  scope :typeahead_history, ::Core::Searches::TypeaheadHistoryQuery
  scope :autocomplete, Schematics::SearchIndexes::AutocompleteQuery
  scope :multisearch, Schematics::SearchIndexes::MultisearchQuery
end
