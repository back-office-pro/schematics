# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Attribute
        class Component < ApplicationComponent
          renders_one_form :form
          with_collection_parameter :constant

          def initialize(form:, constant:)
            super
            @form = form
            @constant = constant
          end

          def entity = Entities::Entity.new(schema:)

          def schema = @form.object
        end
      end
    end
  end
end
