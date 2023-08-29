# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Association
      module HasAndBelongsToMany
        class Component < ApplicationComponent
          delegate :icon, to: 'builder.object'
          option :builder

          def allowed_names = builder
            .object
            .allowed_association_types
            .map(&:pluralize)

          def collection = [Associations::HasAndBelongsToMany]
            .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
            .sort

          def title = t('.title')

          def include_blank = t('prompt', attribute_name:)

          private

          def attribute_name = Associations::HasAndBelongsToMany
            .human_attribute_name('name')
            .downcase
        end
      end
    end
  end
end
