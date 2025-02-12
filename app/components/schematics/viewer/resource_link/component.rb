# frozen_string_literal: true

module Schematics
  module Viewer
    module ResourceLink
      class Component < ApplicationComponent
        renders_one :body
        delegate :deleted?, to: :resource, private: true
        option :resource
        option :tag_name, default: -> { :div }
        option :css_classes, optional: true

        def data
          return unless visitable?

          {
            action: 'click->application#visit',
            'application-href-param': resource_path(resource)
          }
        end

        def role
          return unless visitable?

          'button'
        end

        private

        def visitable?
          !deleted? && can?(:show, resource)
        end
      end
    end
  end
end
