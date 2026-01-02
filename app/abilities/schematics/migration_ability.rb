# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
      cannot %i[archive update], ::Migration.state_generating
      cannot :create, ::Migration if ::Migration.any? && !::Migration.last.state_finished?
      cannot :archive, ::Migration.current if ::Migration.current
      cannot %i[update migrate rollback schedule unschedule], ::Migration.excluding(::Migration.last) # rubocop:disable Layout/LineLength
    end
  end
end
