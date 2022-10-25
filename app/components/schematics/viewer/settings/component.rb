# frozen_string_literal: true

module Schematics
  module Viewer
    module Settings
      class Component < ApplicationComponent
        delegate :listable_elements, :table_name, :model_class, to: :entity
        option :entity
      end
    end
  end
end
