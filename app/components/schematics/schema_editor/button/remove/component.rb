# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module Remove
        class Component < ApplicationComponent
          option :wrapper

          def title = t('.title')
        end
      end
    end
  end
end
