# frozen_string_literal: true

module Schematics
  module Commands
    # :reek:Attribute
    class Command
      include ::ActiveModel::API

      delegate :name,
               :table_name,
               :class_name,
               :migratable_attributes,
               :association_attributes,
               :has_and_belongs_to_many_associations,
               :core?,
               to: :entity
      attr_accessor :entity, :attribute, :target

      class << self
        def build(type:, **kwargs)
          Commands.const_get(type.camelize.to_sym).new(**kwargs)
        end
      end

      def execute
        raise NotImplementedError
      end
    end
  end
end
