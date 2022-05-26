# frozen_string_literal: true

module Schematics
  module Navbar
    module SearchBar
      class Component < ApplicationComponent
        def data = {
          'bs-toggle': 'modal',
          'bs-target': '#search-bar-modal'
        }
      end
    end
  end
end
