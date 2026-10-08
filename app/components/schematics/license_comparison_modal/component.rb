# frozen_string_literal: true

module Schematics
  module LicenseComparisonModal
    class Component < ApplicationComponent
      def title = t('.title')

      def icon = :lock_open

      def quota = Schematics::License::QUOTA
    end
  end
end
