# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :entity, to: '::Migration'
      delegate :company_name, to: '::Configuration'
      delegate :year, to: '::Time.current'
      delegate :icon, to: :entity

      def resource = ::Migration
        .with_string_translations
        .current
    end
  end
end
