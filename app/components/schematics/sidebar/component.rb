# frozen_string_literal: true

module Schematics
  module Sidebar
    class Component < ApplicationComponent
      delegate :company_name, to: '::Configuration'
      delegate :preferences_sidebar_toggled, to: :current_user

      def model_classes = SchemaCache
        .model_classes
        .reject(&:abstract?)
        .push(::Import, ::Emailing, ::ActiveStorage::Blob)
        .select { can?(:index, it) }
        .sort_by(&:human_name)
    end
  end
end
