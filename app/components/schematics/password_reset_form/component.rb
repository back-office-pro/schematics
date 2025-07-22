# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module PasswordResetForm
    class Component < ApplicationComponent
      def url = password_resets_path

      def model = ::User.new
    end
  end
end
