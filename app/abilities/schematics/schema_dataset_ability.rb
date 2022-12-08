# frozen_string_literal: true

module Schematics
  class SchemaDatasetAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot :import, mod::SchemaDataset
      cannot :create, mod::SchemaDataset if mod::SchemaDataset.any? && !mod::SchemaDataset.last.migrated?
      cannot :manage, mod::SchemaDataset.in_progress
      cannot :update, mod::SchemaDataset.migrated
      cannot :archive, mod::SchemaDataset.current if mod::SchemaDataset.current
    end
  end
end
