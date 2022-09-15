# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Virtual
        class Component < ApplicationComponent
          renders_one_form :form

          def initialize(form:)
            super
            @form = form
          end
        end
      end
    end
  end
end
