# frozen_string_literal: true

module Schematics
  class DemoAbility < ApplicationAbility
    delegate :demo?, to: '::Tenant', private: true

    def initialize
      super
      return unless demo?

      cannot %i[destroy archive], ::User, role: ::Role.admin
      cannot :update, ::User, %i[password password_confirmation email], role: ::Role.admin
    end
  end
end
