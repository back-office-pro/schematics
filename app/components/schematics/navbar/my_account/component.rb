# frozen_string_literal: true

module Schematics
  module Navbar
    module MyAccount
      class Component < ApplicationComponent
        delegate :role, :user_groups, :otp_enabled?, to: :current_user
        delegate :admin_path,
                 :logout_path,
                 :edit_profile_path,
                 :edit_preferences_path,
                 :new_one_time_passwords_path,
                 :one_time_passwords_path,
                 to: 'Schematics::Engine.routes.url_helpers'

        def otp_path
          return one_time_passwords_path if otp_enabled?

          new_one_time_passwords_path
        end
      end
    end
  end
end
