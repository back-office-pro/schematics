# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern

    class_methods do
      def inherited(subclass)
        super
        subclass.class_eval do
          entity.load
        end
      end

      def entity
        Schema
          .instance
          .find_entity_by_name(name.underscore)
      end

      def filter_attributes
        entity
          .non_renderable_attributes
          .map(&:name)
          .map(&:to_sym)
      end
    end
  end
end
