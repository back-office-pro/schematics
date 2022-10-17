# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Trigger
        class Component < ApplicationComponent
          renders_one_form :form

          def initialize(form:)
            super
            @form = form
          end

          def entity = Entities::Entity.new(schema:)

          def schema = @form.object
        end
      end
    end
  end
end
