# frozen_string_literal: true

module Schematics
  class RoleAbility < ApplicationAbility
    def initialize
      super
      cannot %i[duplicate update destroy archive], ::Role.admin
    end
  end
end
