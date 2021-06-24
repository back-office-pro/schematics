# frozen_string_literal: true

module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = 'created_at'
    include ActiveStorageSupport::SupportForBase64
    scope :search_import, -> { with_deleted }

    class << self
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
