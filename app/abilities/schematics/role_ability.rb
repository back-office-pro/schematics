# frozen_string_literal: true

module Schematics
  class RoleAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot %i[update destroy archive], mod::Role.admin
    end
  end
end
