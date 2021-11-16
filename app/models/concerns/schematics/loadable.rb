# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern

    included do
      include ActiveStorageSupport::SupportForBase64
    end

    class_methods do
      attr_reader :concerns

      def inherited(subclass)
        super
        subclass.class_eval do
          if entity
            superclass.concerns.each(&method(:include))
            entity.load
          end
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

      private

      def loadable(concerns: [])
        @concerns = concerns
      end
    end
  end
end
