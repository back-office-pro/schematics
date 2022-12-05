# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Array
        class Component < ApplicationComponent
          delegate :object, to: :builder, private: true
          renders_one_form :builder
          option :builder
          option :name

          def values = Array object.public_send(name)
        end
      end
    end
  end
end
