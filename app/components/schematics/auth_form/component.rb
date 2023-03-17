# frozen_string_literal: true

module Schematics
  module AuthForm
    class Component < ApplicationComponent
      delegate :new_password_reset_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :demo?, to: '::Tenant', private: true

      def url = sessions_path

      def scope = :session

      def model
        return User.new unless demo?

        User.new(email: Tenant.customer_email)
      end

      def value = Tenant.customer_password

      def data = { turbo: false, action: 'submit->application#disableWith' }
    end
  end
end
