# frozen_string_literal: true

module Schematics
  module Button
    module AddComment
      class Component < ApplicationComponent
        delegate :human_name, :gender, to: ::Comment

        def initialize(resource:)
          super
          @resource = resource
        end

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split mx-2]

        def render?
          can?(:create, ::Comment)
        end
      end
    end
  end
end
