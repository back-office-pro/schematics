# frozen_string_literal: true

module Core
  module Permissions
    class FeaturesQuery < Schematics::ApplicationQuery
      def call = where(model: %w[Core::Import Core::Message Core::Comment Core::Meeting Core::Task])
        .or(where(model: 'Core::Chart', action: 'show'))
        .or(where(model: 'ActiveStorage::Blob', action: 'index'))
    end
  end
end
