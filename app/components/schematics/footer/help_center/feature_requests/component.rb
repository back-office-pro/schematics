# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Footer
    module HelpCenter
      module FeatureRequests
        class Component < ApplicationComponent
          def title = t('.text')

          def icon = :comment_dots

          def url = ::URI::HTTPS
            .build(host:, path:)
            .to_s

          def target = '_blank'

          def rel = 'noreferrer'

          def icon_css_classes = %w[me-3]

          def wrapper_css_classes = %w[dropdown-item]

          private

          def host = 'backofficepro.canny.io'

          def path = '/feature-requests'
        end
      end
    end
  end
end
