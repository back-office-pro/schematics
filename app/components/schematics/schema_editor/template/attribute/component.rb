# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Attribute
        class Component < ApplicationComponent
          with_collection_parameter :constant

          def initialize(form:, constant:)
            super
            @form = form
            @constant = constant
          end

          def attribute = @constant.new(id: 'RANDOM_UUID', entity:)

          def entity = Entities::Entity.new(id: 'RANDOM_UUID', schema:)

          def schema = @form.object
        end
      end
    end
  end
end
