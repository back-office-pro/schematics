# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module String
        class Component < ApplicationComponent
          delegate :name, to: :option

          option :builder
          option :option
        end
      end
    end
  end
end
