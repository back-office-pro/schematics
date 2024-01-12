# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Polymorphic
        class Component < ApplicationComponent
          delegate :name, to: :option

          option :builder
          option :option
          option :object

          def field = object
            .dup
            .tap { _1.name = name }
        end
      end
    end
  end
end
