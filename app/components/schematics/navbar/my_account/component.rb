# frozen_string_literal: true

module Schematics
  module Navbar
    module MyAccount
      class Component < ApplicationComponent
        delegate :role, :user_groups, to: :current_user
        delegate :admin_path,
                 :logout_path,
                 :edit_profile_path,
                 :edit_preferences_path,
                 :one_time_passwords_path,
                 to: 'Schematics::Engine.routes'
      end
    end
  end
end
