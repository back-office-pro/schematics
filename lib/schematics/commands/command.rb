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
               to: :entity,
               private: true
      attr_accessor :entity, :attribute, :target

      def generators = []

      def weight = 1

      protected

      def model_exists?
        Object.const_defined?(class_name)
      end

      # :reek:FeatureEnvy
      def has_and_belongs_to_many_associations = entity # rubocop:disable Naming/PredicateName
        .has_and_belongs_to_many_associations
        .reject { _1.entity.name.pluralize == _1.name }
    end
  end
end
