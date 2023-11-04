# frozen_string_literal: true

module Schematics
  module Navbar
    module MyAccount
      class Component < ApplicationComponent
        delegate :role, :user_groups, :otp_enabled?, to: :current_user
        delegate :url_helpers, to: 'Schematics::Engine.routes', private: true
        delegate :admin_path,
                 :logout_path,
                 :edit_profile_path,
                 :edit_preferences_path,
                 :new_one_time_passwords_path,
                 to: :url_helpers

        def one_time_passwords_path
          return new_one_time_passwords_path unless otp_enabled?

          url_helpers.one_time_passwords_path
        end
      end
    end
  end
end
