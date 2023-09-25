# frozen_string_literal: true

module Schematics
  class MigrationAbility < ApplicationAbility
    def initialize
      super
      cannot :import, ::Migration
      cannot :update, ::Migration.finished
      cannot :create, ::Migration if ::Migration.any? && !::Migration.last.finished?
      cannot :archive, ::Migration.current if ::Migration.current
      cannot %i[archive update], ::Migration.in_progress
      cannot %i[update migrate rollback], ::Migration.excluding(::Migration.last)
    end
  end
end
