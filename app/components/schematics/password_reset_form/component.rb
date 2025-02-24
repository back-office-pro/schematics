# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module PasswordResetForm
    class Component < ApplicationComponent
      delegate :password_resets_path, to: 'Schematics::Engine.routes.url_helpers'

      def url = password_resets_path

      def model = current_module::User.new
    end
  end
end
