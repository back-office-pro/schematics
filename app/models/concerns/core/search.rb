# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Search
    extend ActiveSupport::Concern

    prepended do
      scope :history, Searches::HistoryQuery
      scope :typeahead_history, Searches::TypeaheadHistoryQuery
      scope :autocomplete, Schematics::SearchIndexes::AutocompleteQuery
      scope :multisearch, Schematics::SearchIndexes::MultisearchQuery
    end
  end
end
