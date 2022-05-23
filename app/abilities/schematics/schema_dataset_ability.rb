# frozen_string_literal: true

module Schematics
  class SchemaDatasetAbility < ApplicationAbility
    def initialize
      super
      cannot :import, ::SchemaDataset
      cannot :destroy, ::SchemaDataset.migrated
    end
  end
end
