# frozen_string_literal: true

module Schematics
  module Viewer
    module Association
      module Button
        class Component < ApplicationComponent
          delegate :reflection, :owner, :klass, to: :proxy_association, allow_nil: true
          delegate :inverse_of, to: :reflection, allow_nil: true, private: true
          option :proxy_association

          def data = { controller: 'tooltip' }

          def title = t('.title')

          def icon = :list

          def css_classes = %w[btn]

          def filter = { inverse_of&.name => owner&.to_s }

          def render? = filter
            .keys
            .any?
        end
      end
    end
  end
end
