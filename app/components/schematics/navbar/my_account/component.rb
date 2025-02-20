# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Navbar
    module MyAccount
      class Component < ApplicationComponent
        delegate :role, :teams, to: :current_user
        delegate :admin_path,
                 :logout_path,
                 :edit_profile_path,
                 :edit_preferences_path,
                 :one_time_passwords_path,
                 to: 'Schematics::Engine.routes.url_helpers'
      end
    end
  end
end
