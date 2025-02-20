# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module PreferencesTable
    module Toggle
      class Component < ApplicationComponent
        delegate :preferences, to: :current_user, private: true
        option :action
        option :model_class

        def preference = "#{action}_#{model_class}"

        def checked?
          preferences.fetch(preference, true)
        end

        def render?
          can?(action.to_sym, model_class)
        end
      end
    end
  end
end
