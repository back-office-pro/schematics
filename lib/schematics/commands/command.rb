# frozen_string_literal: true

require 'active_model'

module Schematics
  module Commands
    # :reek:Attribute
    class Command
      include Behaviours::Specifiable
      include ::ActiveModel::API

      delegate :human, to: :model_name, private: true
      delegate :table_name, to: :source_entity, private: true
      delegate :name,
               :class_name,
               :association_attributes,
               :migratable_attributes,
               :actions_with_events,
               :core?,
               :existing?,
               :source_entity,
               :children,
               :abstract?,
               :child?,
               :schema,
               to: :entity,
               private: true
      attr_accessor :entity, :attribute, :target

      def generators = []

      def weight = 1

      protected

      def translatable_elements = entity
        .fields
        .concat(has_and_belongs_to_many_associations)
        .concat(entity.enum_attributes.flat_map(&:enum_values))
        .concat(entity.state_machine_attributes.flat_map(&:events))

      def has_and_belongs_to_many_associations = entity # rubocop:disable Naming/PredicatePrefix
        .has_and_belongs_to_many_associations
        .reject(&:hidden?)

      def spec_interpolations = super.merge(
        attribute: attribute.try(:name) || attribute,
        target: target.try(:name) || target
      )
    end
  end
end
