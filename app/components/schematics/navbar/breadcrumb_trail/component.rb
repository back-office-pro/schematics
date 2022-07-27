# frozen_string_literal: true

module Schematics
  module Navbar
    module BreadcrumbTrail
      class Component < ApplicationComponent
        delegate :root_path, to: 'Schematics::Engine.routes.url_helpers'

        def data = {
          controller: 'hotkey',
          'hotkey-shortcut-value': 'Control+h'
        }
      end
    end
  end
end
