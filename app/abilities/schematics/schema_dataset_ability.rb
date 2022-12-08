# frozen_string_literal: true

module Schematics
  class SchemaDatasetAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot :import, mod::SchemaDataset
      cannot :manage, mod::SchemaDataset.in_progress
      cannot :update, mod::SchemaDataset.migrated
      cannot :archive, mod::SchemaDataset.current if mod::SchemaDataset.current
      if mod::SchemaDataset.any? && !mod::SchemaDataset.last.migrated?
        cannot :create, mod::SchemaDataset
      end
    end
  end
end
