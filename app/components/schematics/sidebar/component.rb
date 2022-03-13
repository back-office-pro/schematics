# frozen_string_literal: true

module Schematics
  module Sidebar
    class Component < ApplicationComponent
      delegate :can?, :settings, :preferences, to: :helpers

      def toggled?
        preferences(:sidebar_toggled, false)
      end

      def entities
        Schema
          .instance
          .entities
          .select { can?(:index, _1.model_class) }
          .sort_by { _1.model_class.human_name }
      end
    end
  end
end
