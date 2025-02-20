# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_model'

module Schematics
  module Commands
    # :reek:Attribute
    class Command
      include Behaviours::Specifiable
      include ::ActiveModel::API

      delegate :human, to: :model_name, private: true
      delegate :name,
               :table_name,
               :class_name,
               :association_attributes,
               :actions_with_events,
               :core?,
               :existing?,
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

      def has_and_belongs_to_many_associations = entity # rubocop:disable Naming/PredicateName
        .has_and_belongs_to_many_associations
        .reject(&:hidden?)

      def migratable_attributes = entity
        .migratable_attributes
        .push('slug:string:uniq', 'lock_version:integer', 'deleted_at:datetime:index')
        .map(&:to_s)

      def spec_interpolations = super.merge(
        attribute: attribute.try(:name) || attribute,
        target: target.try(:name) || target
      )
    end
  end
end
