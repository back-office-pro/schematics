# frozen_string_literal: true

module Schematics
  class SchemaDatasetAbility < ApplicationAbility
    def initialize
      super
      cannot :import, ::SchemaDataset
      cannot :create, ::SchemaDataset unless ::SchemaDataset.last&.migrated?
      cannot :manage, ::SchemaDataset.in_progress
      cannot :update, ::SchemaDataset.migrated
      cannot :archive, ::SchemaDataset.current if ::SchemaDataset.current
    end
  end
end
