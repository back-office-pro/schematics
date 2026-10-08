# frozen_string_literal: true

module Schematics
  class MigrationAbility < ApplicationAbility
    def initialize
      super
      cannot %i[import duplicate], ::Migration
      cannot :update, ::Migration.state_finished
      cannot %i[archive update], ::Migration.state_pending
      cannot %i[archive update], ::Migration.state_in_progress
      cannot %i[archive update], ::Migration.state_rollbacking
      cannot %i[archive update], ::Migration.state_reasoning
      cannot :create, ::Migration if ::Migration.any? && !::Migration.last.state_finished?
      cannot :archive, ::Migration.current if ::Migration.current
      cannot %i[update migrate rollback schedule unschedule], ::Migration.excluding(::Migration.last) # rubocop:disable Layout/LineLength
    end
  end
end
