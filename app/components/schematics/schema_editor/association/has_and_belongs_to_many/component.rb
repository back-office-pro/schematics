# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Association
      module HasAndBelongsToMany
        class Component < ApplicationComponent
          renders_one_form :builder

          def initialize(builder:)
            super
            @builder = builder
          end

          def associations_collection = Schema
            .instance
            .entities
            .reject(&:core?)
            .map(&:name)
            .sort

          def collection = [Associations::HasAndBelongsToMany]
            .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
            .sort

          def icon = :link

          def selected = @builder
            .object
            .name
            .singularize

          def title = t('.title')
        end
      end
    end
  end
end
