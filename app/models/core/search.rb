# frozen_string_literal: true

module Core
  module Search
    extend ActiveSupport::Concern

    prepended do
      scope :history, HistoryQuery
      scope :typeahead_history, TypeaheadHistoryQuery
    end
  end
end
