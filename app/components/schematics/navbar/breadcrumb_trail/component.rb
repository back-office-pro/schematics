# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Navbar
    module BreadcrumbTrail
      class Component < ApplicationComponent
        use_helpers :breadcrumb_trail

        def title = 'Control+h'

        def data = {
          controller: 'hotkey',
          'hotkey-shortcut-value': title
        }
      end
    end
  end
end
