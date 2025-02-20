# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Footer
    module HelpCenter
      module Terms
        class Component < ApplicationComponent
          delegate :url, to: '::Server'

          def title = t('.text')

          def icon = :file_contract

          def path = t('.path')

          def target = '_blank'

          def rel = 'noreferrer'

          def icon_css_classes = %w[fa-fw me-3]

          def wrapper_css_classes = %w[dropdown-item]
        end
      end
    end
  end
end
