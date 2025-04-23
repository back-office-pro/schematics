# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Sidebar
    class Component < ApplicationComponent
      delegate :company_name, to: '::Configuration'
      delegate :preferences_sidebar_toggled, to: :current_user

      def model_classes = current_schema
        .model_classes
        .push(::Import, ::Emailing, ::ActiveStorage::Blob)
        .select { can?(:index, _1) }
        .sort_by(&:human_name)
    end
  end
end
