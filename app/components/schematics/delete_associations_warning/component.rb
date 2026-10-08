# frozen_string_literal: true

module Schematics
  module DeleteAssociationsWarning
    class Component < ApplicationComponent
      option :resource

      delegate :class, to: :resource, prefix: :model, private: true
      delegate :human_name, :gender, to: :model_class, private: true

      memoize def associations
        resource.associations(current_ability, dependent: true)
      end

      def text
        t('schematics.application.delete.warning', human_name:, gender:, resource:)
      end

      def render?
        associations.any?
      end
    end
  end
end
