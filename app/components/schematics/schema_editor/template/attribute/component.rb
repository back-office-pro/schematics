# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Attribute
        class Component < Template::Component
          with_collection_parameter :constant
          attr_reader :form

          def initialize(form:, constant:)
            super
            @form = form
            @constant = constant
          end

          def attribute = @constant.new(id: 'RANDOM_UUID', entity:)
        end
      end
    end
  end
end
