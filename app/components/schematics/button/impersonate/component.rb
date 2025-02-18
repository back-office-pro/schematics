# frozen_string_literal: true

module Schematics
  module Button
    module Impersonate
      class Component < ApplicationComponent
        delegate :email, to: :resource
        option :resource

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-xxl'
        }

        def title = t('.text', user: resource)

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-1]

        def form = { class: 'd-inline' }

        def params = { session: { email: } }

        def sessions_path = resources_path(::Session)

        def render?
          can?(:impersonate, resource)
        end
      end
    end
  end
end
