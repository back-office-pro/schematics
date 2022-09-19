# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Association
        module HasAndBelongsToMany
          class Component < ApplicationComponent
            renders_one_form :form

            def initialize(form:)
              super
              @form = form
            end

            def association = Associations::Association.build(
              type: 'has_and_belongs_to_many',
              entity:,
              name: 'NEW_HABTM_ASSOCIATION'
            )

            def entity = Entities::Entity.new
          end
        end
      end
    end
  end
end
