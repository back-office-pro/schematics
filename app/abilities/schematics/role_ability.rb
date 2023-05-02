# frozen_string_literal: true

module Schematics
  class RoleAbility < ApplicationAbility
    def initialize
      super
      cannot %i[update destroy archive], Core::Role.admin
    end
  end
end
