# frozen_string_literal: true

module Schematics
  module MyAccount
    class Component < ApplicationComponent
      delegate :logout_path,
               :profile_path,
               :admin_path,
               :edit_preferences_path,
               to: 'Schematics::Engine.routes.url_helpers'
    end
  end
end
