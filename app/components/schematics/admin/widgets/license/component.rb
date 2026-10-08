# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module License
        class Component < ApplicationComponent
          delegate :active?, :expires_at, :expires_at_formatted, to: '::Configuration.license'

          def icon = :id_badge

          def text
            return t('.pro') if active?

            t('.free')
          end

          def col_css_classes
            return %w[p-4] if active?

            %w[p-3 m-1]
          end
        end
      end
    end
  end
end
