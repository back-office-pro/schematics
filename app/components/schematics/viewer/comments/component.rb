# frozen_string_literal: true

module Schematics
  module Viewer
    module Comments
      class Component < ApplicationComponent
        delegate :comments, to: :@resource
        delegate :size, to: :comments
        delegate :entity, :human_name, to: :model_class
        delegate :icon, to: :entity

        def initialize(resource:)
          super
          @resource = resource
        end

        def model_class = ::Comment

        def title = "#{size} #{human_name(count: size)}"
      end
    end
  end
end
