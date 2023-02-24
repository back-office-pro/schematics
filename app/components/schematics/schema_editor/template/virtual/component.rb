# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Virtual
        class Component < ApplicationComponent
          option :form

          def entity = Entities::Entity.new(schema:)

          def schema = form.object
        end
      end
    end
  end
end
