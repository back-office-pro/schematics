# frozen_string_literal: true

module Schematics
  module Viewer
    module ResourceLink
      class Component < ApplicationComponent
        renders_one :resource
        delegate :deleted?, to: :@resource

        def initialize(resource:, tag_name: :div, css_classes: nil)
          super
          @resource = resource
          @tag_name = tag_name
          @css_classes = css_classes
        end

        def data
          return unless visitable?

          {
            action: 'click->application#visit',
            'application-href-param': polymorphic_path(@resource)
          }
        end

        def role
          return unless visitable?

          'button'
        end

        private

        def visitable?
          !deleted? && can?(:show, @resource)
        end
      end
    end
  end
end
