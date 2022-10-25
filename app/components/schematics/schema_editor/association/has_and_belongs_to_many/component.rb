# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Association
      module HasAndBelongsToMany
        class Component < ApplicationComponent
          delegate :entity, to: 'builder.object', private: true
          renders_one_form :builder
          option :builder

          def associations_collection = entity
            .schema
            .entities
            .reject(&:core?)
            .map(&:name)
            .sort

          def collection = [Associations::HasAndBelongsToMany]
            .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
            .sort

          def icon = :link

          def selected = builder
            .object
            .name
            .singularize

          def title = t('.title')

          def wrapper = :input_group
        end
      end
    end
  end
end
