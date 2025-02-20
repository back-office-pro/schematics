# Copyright © 2025 Dev & Software. All rights reserved.
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
