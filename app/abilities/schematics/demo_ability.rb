# frozen_string_literal: true

module Schematics
  class DemoAbility < ApplicationAbility
    delegate :demo?, to: ::Tenant, private: true

    def initialize
      super
      return unless demo?

      cannot %i[destroy archive], Core::User, role: Core::Role.admin
      cannot :update, Core::User, %i[password password_confirmation email], role: Core::Role.admin
    end
  end
end
