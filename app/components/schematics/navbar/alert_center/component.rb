# frozen_string_literal: true

module Schematics
  module Navbar
    module AlertCenter
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :icon, to: '::Alert.entity'

        def display_count
          count >= LIMIT ? "#{LIMIT.pred}+" : count
        end

        def icon_class
          return 'fa-lg' if count.zero?

          %w[fa-lg animate__animated animate__pulse animate__slower animate__infinite]
        end

        memoize def count = Alert
          .count

        memoize def versions = Alert
          .limit(LIMIT)

        def render?
          can?(:index, ::Alert)
        end
      end
    end
  end
end
