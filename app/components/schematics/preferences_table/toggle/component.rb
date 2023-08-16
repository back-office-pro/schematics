# frozen_string_literal: true

module Schematics
  module PreferencesTable
    module Toggle
      class Component < ApplicationComponent
        option :action
        option :model_class

        def preference = "#{action}_#{model_class}"

        def checked? = preferences(preference, true)

        def render?
          can?(action.to_sym, model_class)
        end
      end
    end
  end
end
