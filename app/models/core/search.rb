# frozen_string_literal: true

module Core
  class Search < Schematics::ApplicationRecord
    scope :history, Searches::HistoryQuery
    scope :typeahead_history, Searches::TypeaheadHistoryQuery
  end
end
