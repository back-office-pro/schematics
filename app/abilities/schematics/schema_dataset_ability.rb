# frozen_string_literal: true

module Schematics
  class SchemaDatasetAbility < ApplicationAbility
    def initialize
      super
      cannot :import, ::SchemaDataset
      cannot :update, ::SchemaDataset.migrated
      cannot :create, ::SchemaDataset if ::SchemaDataset.any? && !::SchemaDataset.last.migrated?
      cannot :archive, ::SchemaDataset.current if ::SchemaDataset.current
      cannot %i[archive update], ::SchemaDataset.in_progress
    end
  end
end
