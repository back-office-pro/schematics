# frozen_string_literal: true

module Schematics
  module Viewer
    module Comments
      class Component < ApplicationComponent
        delegate :comments, to: :@resource
        delegate :size, to: :comments
        delegate :icon, to: '::Comment.entity'

        def initialize(resource:)
          super
          @resource = resource
        end

        def title = "#{size} #{::Comment.human_name(count: size)}"
      end
    end
  end
end
