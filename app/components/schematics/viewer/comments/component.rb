# frozen_string_literal: true

module Schematics
  module Viewer
    module Comments
      class Component < ApplicationComponent
        delegate :comments, to: :@resource
        delegate :icon, to: '::Comment.entity'

        def initialize(resource:)
          super
          @resource = resource
        end

        def title
          '4 commentaires'
        end
      end
    end
  end
end
