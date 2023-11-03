# frozen_string_literal: true

module Schematics
  module OneTimePasswordForm
    class Component < ApplicationComponent
      delegate :root_path, :one_time_passwords_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :qr_code, to: :resource
      option :resource

      alias model resource
    end
  end
end
