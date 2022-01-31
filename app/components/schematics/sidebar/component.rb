# frozen_string_literal: true

module Schematics
  module Sidebar
    class Component < ApplicationComponent
      delegate :settings, :preferences, to: :helpers
      delegate :cannot?, to: :current_ability

      def toggled?
        preferences(:sidebar_toggled, false)
      end

      def entities
        Schema
          .instance
          .entities
          .sort_by { _1.class_name.constantize.human_name }
      end
    end
  end
end
