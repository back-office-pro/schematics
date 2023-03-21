# frozen_string_literal: true

module Schematics
  module Navbar
    module MeetingCenter
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :icon, to: '::Meeting.entity'

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
                     .active
                     .load_async
                     .size
        end

        def render?
          config(:meetings_feature_flag) && can?(:index, ::Meeting)
        end

        def meetings
          @meetings ||= current_user
                        .meetings
                        .active
                        .with_creator_avatar
                        .order(created_at: :desc)
                        .limit(LIMIT)
        end
      end
    end
  end
end
