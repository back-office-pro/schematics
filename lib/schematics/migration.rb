# frozen_string_literal: true

module Schematics
  # :reek:Attribute :reek:InstanceVariableAssumption
  class Migration
    include ::ActiveModel::API

    delegate :execute, to: :command
    delegate :current_version,
             to: '::ApplicationRecord.connection.migration_context',
             private: true
    attr_accessor :schema, :type, :attribute, :timestamp
    attr_writer :entity

    def migrated?
      timestamp < current_version
    end

    private

    def command
      Commands::Command.build(type:, entity:, attribute:)
    end

    def entity
      schema.find_entity_by_name(@entity)
    end
  end
end
