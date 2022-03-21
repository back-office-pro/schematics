# frozen_string_literal: true

module Schematics
  module SearchBar
    class Component < ApplicationComponent
      def action
        %w[
          keyup->searchBar#search
          search->searchBar#clearResults
          search->searchBar#showHistory
          focus->searchBar#onFocus
          blur->searchBar#hideHistory
          blur->searchBar#hideResults
        ].join(' ')
      end

      def history
        ::Search.user_search_history(current_user)
      end
    end
  end
end
