# frozen_string_literal: true

class Search < Schematics::ApplicationRecord
  scope :history, ::Core::Search::HistoryQuery
  scope :typeahead_history, ::Core::Search::TypeaheadHistoryQuery
end
