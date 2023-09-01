# frozen_string_literal: true

require 'active_model'

module Schematics
  module Commands
    # :reek:Attribute
    class Command
      include ::ActiveModel::API
      include ::ActiveModel::Naming

      delegate :human, to: :model_name, private: true
      delegate :name,
               :table_name,
               :class_name,
               :association_attributes,
               :core?,
               :existing?,
               :schema,
               to: :entity,
               private: true
      attr_accessor :entity, :attribute, :target

      def generators = []

      def to_s = human(name: name.humanize, attribute:, target:)

      def weight = 1

      protected

      def has_and_belongs_to_many_associations = entity # rubocop:disable Naming/PredicateName
        .has_and_belongs_to_many_associations
        .reject(&:hidden?)

      def migratable_attributes = entity
        .migratable_attributes
        .push('slug:string:uniq', 'lock_version:integer')
        .map(&:to_s)
    end
  end
end
