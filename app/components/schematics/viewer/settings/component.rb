# frozen_string_literal: true

module Schematics
  module Viewer
    module Settings
      class Component < ApplicationComponent
        delegate :listable_elements, to: :@entity
        delegate :has_preference?, to: :current_user

        def initialize(entity:)
          super
          @entity = entity
        end

        def model_class
          @entity.class_name.constantize
        end
      end
    end
  end
end
