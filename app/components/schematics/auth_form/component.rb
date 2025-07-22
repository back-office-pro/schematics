# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module AuthForm
    class Component < ApplicationComponent
      delegate :email, :demo?, to: '::Subscription', private: true

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
