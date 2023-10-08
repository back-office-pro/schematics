# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Errors
      class Component < ApplicationComponent
        option :errors

        def render?
          errors.any?
        end
      end
    end
  end
end
