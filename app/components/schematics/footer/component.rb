# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :version, to: '::SchemaDataset.current'
    end
  end
end
