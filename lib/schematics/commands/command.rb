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
               :core?,
               :existing?,
               :schema,
               to: :entity,
               private: true
      attr_accessor :entity, :attribute, :target

      def generators = []

      def weight = 1

      protected

      def has_and_belongs_to_many_associations = entity # rubocop:disable Naming/PredicateName
        .has_and_belongs_to_many_associations
        .reject(&:hidden?)
    end
  end
end
