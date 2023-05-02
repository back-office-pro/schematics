# frozen_string_literal: true

module Schematics
  module Navbar
    module MeetingCenter
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :icon, to: 'Core::Meeting.entity'

        def display_count
          count >= 10 ? '9+' : count
        end

        def icon_class
          return 'fa-lg' if count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        def count
          @count ||= current_user
                     .meetings
                     .to_come
                     .today
                     .accessible_by(current_ability)
                     .load_async
                     .size
        end

        def render?
          can?(:index, Core::Meeting)
        end

        def meetings
          @meetings ||= current_user
                        .meetings
                        .to_come
                        .accessible_by(current_ability)
                        .with_creator_avatar
                        .order(created_at: :desc)
                        .limit(LIMIT)
        end
      end
    end
  end
end
