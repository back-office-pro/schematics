# frozen_string_literal: true

module Schematics
  class MigrationAbility < ApplicationAbility
    def initialize
      super
      cannot :import, ::Migration
      cannot :update, ::Migration.state_finished
      cannot :create, ::Migration if ::Migration.any? && !::Migration.last.state_finished?
      cannot :archive, ::Migration.current if ::Migration.current
      cannot %i[archive update], ::Migration.state_in_progress
      cannot %i[update migrate rollback], ::Migration.excluding(::Migration.last)
    end
  end
end
