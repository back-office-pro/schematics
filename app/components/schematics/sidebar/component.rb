# frozen_string_literal: true

module Schematics
  module Sidebar
    class Component < ApplicationComponent
      delegate :settings, :preferences, to: :helpers
      delegate :entities, to: 'Schematics::Schema.instance'
      delegate :cannot?, to: :current_ability

      def toggled?
        preferences(:sidebar_toggled)
      end
    end
  end
end
