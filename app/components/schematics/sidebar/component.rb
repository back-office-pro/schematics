# frozen_string_literal: true

module Schematics
  module Sidebar
    class Component < ApplicationComponent
      delegate :settings, :preferences, to: :helpers

      def toggled?
        preferences(:sidebar_toggled, false)
      end

      def entities
        Schema
          .instance
          .entities
          .select { _1.can?(:index) }
          .sort_by { _1.class_name.constantize.human_name }
      end
    end
  end
end
