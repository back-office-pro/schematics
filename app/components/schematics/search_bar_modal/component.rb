# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
