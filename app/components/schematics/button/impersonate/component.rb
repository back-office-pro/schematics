# frozen_string_literal: true

module Schematics
  module Button
    module Impersonate
      class Component < ApplicationComponent
        delegate :email, to: :resource
        option :resource

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-2]

        def data = { turbo: false }

        def form = { class: 'd-inline' }

        def params = { session: { email: } }

        def render?
          can?(:impersonate, resource)
        end
      end
    end
  end
end
