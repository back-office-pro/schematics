# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Association
      module HasAndBelongsToMany
        class Component < ApplicationComponent
          renders_one_form :builder
          option :builder

          def collection = [Associations::HasAndBelongsToMany]
            .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
            .sort

          def allowed_names = builder
            .object
            .allowed_names
            .map(&:pluralize)

          def icon = :link

          def title = t('.title')

          def wrapper = :input_group
        end
      end
    end
  end
end
