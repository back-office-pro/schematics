# frozen_string_literal: true

module Schematics
  module Viewer
    module Settings
      class Component < ApplicationComponent
        delegate :listable_elements, to: :@entity
        delegate :preferences, to: :current_user

        def initialize(entity:)
          super
          @entity = entity
        end

        def model_class
          @entity.class_name.constantize
        end

        def checked?(preference)
          preferences.fetch(preference, true)
        end
      end
    end
  end
end
