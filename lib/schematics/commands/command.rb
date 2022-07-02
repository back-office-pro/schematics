# frozen_string_literal: true

require 'active_model'

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

      def execute
        raise NotImplementedError
      end

      def weight = 1
    end
  end
end
