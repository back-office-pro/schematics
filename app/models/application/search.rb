# frozen_string_literal: true

module Application
  module Search
    extend ActiveSupport::Concern

    prepended do
      scope :history, HistoryQuery
      scope :typeahead_history, TypeaheadHistoryQuery
    end
  end
end
