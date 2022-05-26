# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      def version
        ::SchemaDataset.current_version || '1.0'
      end
    end
  end
end
