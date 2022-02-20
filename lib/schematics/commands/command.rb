# frozen_string_literal: true

module Schematics
  module Commands
    class Command
      delegate :name,
               :table_name,
               :class_name,
               :migratable_attributes,
               :association_attributes,
               :has_and_belongs_to_many_associations,
               to: :@entity

      class << self
        def build(command:, entity:, attribute: nil)
          Commands.const_get(command.camelize.to_sym).new(entity, attribute)
        end
      end

      def initialize(entity, attribute = nil)
        @entity = entity
        @attribute = attribute
      end

      def execute
        raise NotImplementedError
      end
    end
  end
end
