# frozen_string_literal: true

module Schematics
  module AuthForm
    class Component < ApplicationComponent
      delegate :new_password_reset_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :demo?, :customer_email, :customer_password, to: ::Tenant, private: true

      def url = sessions_path

      def scope = :session

      def model
        return ::User.new unless demo?

        ::User.new(email: customer_email)
      end

      def value = customer_password

      def data = { turbo: false, action: 'submit->application#disableWith' }
    end
  end
end
