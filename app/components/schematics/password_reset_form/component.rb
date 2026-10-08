# frozen_string_literal: true

module Schematics
  module PasswordResetForm
    class Component < ApplicationComponent
      delegate :bootstrap_form_with, to: :helpers

      def url = password_resets_path

      def model = ::User.new
    end
  end
end
