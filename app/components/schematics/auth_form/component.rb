# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module AuthForm
    class Component < ApplicationComponent
      delegate :new_password_reset_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :demo?, to: :current_tenant, private: true
      delegate :email, to: '::Subscription', private: true

      def url = resources_path(::Session)

      def scope = :session

      def model
        return ::User.new unless demo?

        ::User.new(email:)
      end

      def value
        Attributes::Digest::DEFAULT if demo?
      end
    end
  end
end
