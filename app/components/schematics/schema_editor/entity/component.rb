# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Entity
      class Component < ApplicationComponent
        delegate :icon, to: '::Migration.entity'
        delegate :index, to: :builder
        option :builder

        def title = builder
          .object
          .class
          .model_name
          .human
      end
    end
  end
end
