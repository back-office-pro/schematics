# frozen_string_literal: true

module Schematics
  module ResourceLinkTo
    class Component < ApplicationComponent
      renders_one :body
      option :resource
      option :css_classes, optional: true

      def data = { turbo_frame: '_top' }

      def ability
        case resource
        when Class
          :index
        else
          :show
        end
      end
    end
  end
end
