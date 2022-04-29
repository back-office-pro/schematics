# frozen_string_literal: true

module Schematics
  module MyAccount
    class Component < ApplicationComponent
      delegate :admin_path,
               :logout_path,
               :edit_profile_path,
               :edit_preferences_path,
               to: 'Schematics::Engine.routes.url_helpers'
    end
  end
end
