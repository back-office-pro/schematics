# frozen_string_literal: true

module Schematics
  module Navbar
    module TaskCenter
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :icon, to: 'Core::Task.entity'

        def display_count
          count >= 10 ? '9+' : count
        end

        def icon_class
          return 'fa-lg' if count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        def count
          @count ||= current_user
                     .tasks
                     .not_state_completed
                     .not_state_aborted
                     .accessible_by(current_ability)
                     .load_async
                     .size
        end

        def render?
          can?(:index, Core::Task)
        end

        def tasks
          @tasks ||= current_user
                     .tasks
                     .not_state_completed
                     .not_state_aborted
                     .accessible_by(current_ability)
                     .with_applicant_avatar
                     .order(deadline: :asc)
                     .limit(LIMIT)
        end
      end
    end
  end
end
