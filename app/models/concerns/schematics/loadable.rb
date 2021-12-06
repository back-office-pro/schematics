# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern

    included do
      include ActiveStorageSupport::SupportForBase64
      include AASM
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

    def method_missing(method_name, *args, &block)
      return super unless method_name.end_with?('_formatted')

      field_name = method_name.to_s.chomp('_formatted')
      value = public_send(field_name)
      self
        .class
        .entity
        .find_field_by_name(field_name)
        .try(:format, value) || value
    end

    def respond_to_missing?(method_name, *args)
      method_name.end_with?('_formatted') || super
    end
  end
end
