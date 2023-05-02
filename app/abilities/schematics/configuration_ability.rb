# frozen_string_literal: true

module Schematics
  class ConfigurationAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can %i[show update], Core::Configuration
    end
  end
end
