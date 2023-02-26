# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Association
      module HasAndBelongsToMany
        class Component < ApplicationComponent
          delegate :allowed_names, to: 'builder.object'
          option :builder

          def collection = [Associations::HasAndBelongsToMany]
            .map { [_1.model_name.human, _1.to_s.demodulize.underscore] }
            .sort

          def icon = :link

          def title = t('.title')
        end
      end
    end
  end
end
