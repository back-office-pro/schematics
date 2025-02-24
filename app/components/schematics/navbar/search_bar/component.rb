# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Navbar
    module SearchBar
      class Component < ApplicationComponent
        def title = 'Control+s'

        def data = {
          controller: 'hotkey',
          'hotkey-shortcut-value': title,
          'bs-toggle': 'modal',
          'bs-target': '#search-bar-modal'
        }

        def render?
          can?(:create, current_module::Search)
        end
      end
    end
  end
end
