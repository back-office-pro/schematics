# frozen_string_literal: true

module Schematics
  module SecondFactorForm
    class Component < ApplicationComponent
      delegate :root_path, :one_time_password_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :qr_code, :user, to: :resource
      option :resource

      def url = one_time_password_path

      alias model user
    end
  end
end
