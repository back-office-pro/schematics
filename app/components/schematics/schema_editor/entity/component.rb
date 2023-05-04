# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Entity
      class Component < ApplicationComponent
        delegate :icon, to: '::SchemaDataset.entity'
        delegate :index, to: :builder
        option :builder

        # :reek:NilCheck
        def template? = builder
          .object
          .name
          .nil?

        def title = builder
          .object
          .class
          .model_name
          .human
      end
    end
  end
end
