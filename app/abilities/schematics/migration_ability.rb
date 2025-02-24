# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class MigrationAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot %i[import duplicate], mod::Migration
      cannot :update, mod::Migration.state_finished
      cannot %i[archive update], mod::Migration.state_pending
      cannot %i[archive update], mod::Migration.state_in_progress
      cannot %i[archive update], mod::Migration.state_rollbacking
      cannot %i[archive update], mod::Migration.state_generating
      cannot :create, mod::Migration if mod::Migration.any? && !mod::Migration.last.state_finished?
      cannot :archive, mod::Migration.current if mod::Migration.current
      cannot %i[update migrate rollback schedule unschedule], mod::Migration.excluding(mod::Migration.last) # rubocop:disable Layout/LineLength
    end
  end
end
