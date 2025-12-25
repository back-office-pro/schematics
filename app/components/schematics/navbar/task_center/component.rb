# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Navbar
    module TaskCenter
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :icon, to: '::Task.entity'

        def tasks_path = resources_path(::Task)

        def display_count
          count >= LIMIT ? "#{LIMIT.pred}+" : count
        end

        def icon_class
          return 'fa-lg' if count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        memoize def count = current_user
          .tasks
          .not_state_completed
          .not_state_aborted
          .accessible_by(current_ability)
          .async_count
          .value

        def render?
          can?(:index, ::Task)
        end

        memoize def tasks = current_user
          .tasks
          .not_state_completed
          .not_state_aborted
          .accessible_by(current_ability)
          .with_applicant
          .with_applicant_avatar
          .with_string_translations
          .order(deadline: :asc)
          .limit(LIMIT)
      end
    end
  end
end
