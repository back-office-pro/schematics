# frozen_string_literal: true

module Schematics
  module Navbar
    module MeetingCenter
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :icon, to: '::Meeting.entity'

        def meetings_path = resources_path(::Meeting)

        def display_count
          count >= LIMIT ? "#{LIMIT.pred}+" : count
        end

        def icon_class
          return 'fa-lg' if count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        memoize def count = current_user
          .meetings
          .to_come
          .today
          .accessible_by(current_ability)
          .async_count
          .value

        def render?
          can?(:index, ::Meeting)
        end

        memoize def meetings = current_user
          .meetings
          .to_come
          .accessible_by(current_ability)
          .with_creator
          .with_creator_avatar
          .with_string_translations
          .order(created_at: :desc)
          .limit(LIMIT)
      end
    end
  end
end
