# frozen_string_literal: true

class Search < Schematics::ApplicationRecord
  scope :history, ::Core::Searches::HistoryQuery
  scope :typeahead_history, ::Core::Searches::TypeaheadHistoryQuery
end
