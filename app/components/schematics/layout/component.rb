# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Layout
    class Component < ApplicationComponent
      delegate :preferences_sidebar_toggled, to: :current_user, private: true

      def css_class
        'toggled' if preferences_sidebar_toggled
      end
    end
  end
end
