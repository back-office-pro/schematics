# frozen_string_literal: true

module Schematics
  module Navbar
    module BreadcrumbTrail
      class Component < ApplicationComponent
        delegate :breadcrumb_trail, to: :helpers

        def title = 'Control+h'

        def data = {
          controller: 'hotkey',
          'hotkey-shortcut-value': title
        }
      end
    end
  end
end
