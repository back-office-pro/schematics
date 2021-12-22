# frozen_string_literal: true

module Schematics
  module SearchBar
    class Component < ApplicationComponent
      delegate :searches_path, to: 'Schematics::Engine.routes.url_helpers'

      def action
        %w[
          keyup->searchBar#search
          search->searchBar#clearResults
          focus->searchBar#showResults
          blur->searchBar#hideResults
        ].join(' ')
      end
    end
  end
end
