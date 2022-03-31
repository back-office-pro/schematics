# frozen_string_literal: true

module Schematics
  module Viewer
    module Settings
      class Component < ApplicationComponent
        delegate :listable_elements, :model_class, to: :@entity

        def initialize(entity:)
          super
          @entity = entity
        end
      end
    end
  end
end
