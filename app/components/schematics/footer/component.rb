# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :current_version, :entity, to: '::SchemaDataset'
      delegate :icon, to: :entity
      delegate :year, to: '::Time.current'
    end
  end
end
