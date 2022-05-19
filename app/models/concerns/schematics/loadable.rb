# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern

    included do
      include ActiveStorageSupport::SupportForBase64
      include AASM
      strip_attributes
      attribute_method_suffix '_formatted'
    end

    class_methods do
      attr_reader :concerns

      def inherited(subclass)
        super
        subclass.class_eval do
          superclass.concerns.each(&method(:include))
          entity&.load
        end
      end

      def entity = Schema
        .instance
        .find_entity_by_name(name.underscore)

      def filter_attributes = entity
        .non_renderable_attributes
        .map(&:name)
        .map(&:to_sym)

      def finder(id)
        case entity
        when Entities::Singleton
          instance
        else
          find(id)
        end
      end

      def reload!
        return unless File.exist?(model_filepath)

        module_parent.__send__(:remove_const, name.demodulize.to_sym)
        load(model_filepath)
      end

      private

      def loadable(concerns: [])
        @concerns = concerns
      end

      def model_filepath = Rails
        .root
        .join('app', 'models', "#{name.underscore}.rb")
    end

    def attribute_formatted(attr)
      self
        .class
        .entity
        &.find_field_by_name(attr)
        &.format(public_send(attr)) || public_send(attr)
    end
  end
end
