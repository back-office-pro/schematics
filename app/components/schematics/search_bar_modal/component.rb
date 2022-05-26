# frozen_string_literal: true

module Schematics
  module SearchBarModal
    class Component < ApplicationComponent
      delegate :search_history, to: :current_user

      def action = %w[
        keyup->search-bar#search
        search->search-bar#clearResults
        search->search-bar#showHistory
        focus->search-bar#onFocus
        blur->search-bar#hideHistory
        blur->search-bar#hideResults
      ].join(' ')
    end
  end
end
