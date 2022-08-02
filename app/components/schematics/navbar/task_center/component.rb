# frozen_string_literal: true

module Schematics
  module Navbar
    module TaskCenter
      class Component < ApplicationComponent
        TASKS_LIMIT = 10

        def display_pending_count
          pending_count >= 10 ? '9+' : pending_count
        end

        def icon_class
          return 'fa-lg' if pending_count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        def pending_count
          @pending_count ||= current_user
                             .tasks
                             .pending
                             .load_async
                             .size
        end

        def render?
          settings(:tasks_feature_flag)
        end

        def tasks
          @tasks ||= current_user
                     .tasks
                     .pending
                     .order(created_at: :desc)
                     .limit(TASKS_LIMIT)
        end
      end
    end
  end
end
