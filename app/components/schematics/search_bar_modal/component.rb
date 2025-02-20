# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SearchBarModal
    class Component < ApplicationComponent
      delegate :history, to: 'current_user.searches'

      def url = resources_path(::Search)

      def model = ::Search.new

      def action = %w[
        keyup->search-bar#search
        search->search-bar#clearResults
        search->search-bar#showHistory
        focus->search-bar#onFocus
        blur->search-bar#hideHistory
        blur->search-bar#hideResults
      ].join(' ')

      def render?
        can?(:create, ::Search)
      end
    end
  end
end
