# frozen_string_literal: true

module Schematics
  module AuthForm
    class Component < ApplicationComponent
      delegate :new_password_reset_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :demo?, :default_password, to: ::Tenant, private: true
      delegate :email, to: ::Licence, private: true

      def url = sessions_path

      def scope = :session

      def model
        return ::User.new unless demo?

        ::User.new(email:)
      end

      def value = default_password

      def data = { turbo: false, action: 'submit->application#disableWith' }
    end
  end
end
