# frozen_string_literal: true

module Schematics
  module Navbar
    module SearchBar
      class Component < ApplicationComponent
        def data = {
          controller: 'hotkey',
          'hotkey-shortcut-value': 'Control+s',
          'bs-toggle': 'modal',
          'bs-target': '#search-bar-modal'
        }

        def render?
          can?(:create, ::Search)
        end
      end
    end
  end
end
