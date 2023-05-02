# frozen_string_literal: true

module Schematics
  class SchemaDatasetAbility < ApplicationAbility
    def initialize
      super
      cannot :import, Core::SchemaDataset
      cannot :create, Core::SchemaDataset if Core::SchemaDataset.any? && !Core::SchemaDataset.last.migrated? # rubocop:disable Layout/LineLength
      cannot :update, Core::SchemaDataset.in_progress
      cannot :update, Core::SchemaDataset.migrated
      cannot :archive, Core::SchemaDataset.current if Core::SchemaDataset.current
    end
  end
end
