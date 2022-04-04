# frozen_string_literal: true

module Schematics
  module SearchBar
    class Component < ApplicationComponent
      def action
        %w[
          keyup->search-bar#search
          search->search-bar#clearResults
          search->search-bar#showHistory
          focus->search-bar#onFocus
          blur->search-bar#hideHistory
          blur->search-bar#hideResults
        ].join(' ')
      end

      def history
        ::Search.user_search_history(current_user)
      end
    end
  end
end
