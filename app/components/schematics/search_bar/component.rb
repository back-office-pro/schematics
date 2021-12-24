# frozen_string_literal: true

module Schematics
  module SearchBar
    class Component < ApplicationComponent
      delegate :searches_path, :search_path, to: 'Schematics::Engine.routes.url_helpers'

      def action
        %w[
          keyup->searchBar#search
          search->searchBar#clearResults
          focus->searchBar#showResults
          focus->searchBar#showHistory
          blur->searchBar#hideResults
          blur->searchBar#hideHistory
        ].join(' ')
      end

      def history
        Search
          .where(user: current_user, model: nil)
          .where
          .not(query: nil)
          .order(created_at: :desc)
          .limit(5)
          .pluck(:query)
          .uniq
      end
    end
  end
end
