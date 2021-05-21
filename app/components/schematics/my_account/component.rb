# frozen_string_literal: true

module Schematics
  module MyAccount
    class Component < ApplicationComponent
      delegate :can?, :admin?, to: :current_ability
      delegate :logout_path,
               :profile_path,
               :edit_preferences_path,
               to: 'Schematics::Engine.routes.url_helpers'
    end
  end
end
