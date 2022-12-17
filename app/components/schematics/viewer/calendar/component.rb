# frozen_string_literal: true

module Schematics
  module Viewer
    module Calendar
      class Component < Viewer::Component
        CALENDAR_START = Entities::Entity::CALENDAR_START
        CALENDAR_END = Entities::Entity::CALENDAR_END

        def alert_css_classes_for(resource, date)
          %w[alert alert-secondary calendar lh-lg text-truncate mb-1 p-2]
            .concat alert_border_css_classes_for(resource, date)
        end

        def date_range = (start_date..end_date).to_a

        def previous_resource_for?(resource, date)
          resources_for(date.yesterday).include?(resource)
        end

        def resources_for(date)
          resources.select do |resource|
            start_date = resource.public_send(CALENDAR_START).beginning_of_day
            end_date = resource.public_send(CALENDAR_END).end_of_day
            (start_date..end_date).cover?(date)
          end
        end

        def tbody_css_classes
          params.dig(filter_key, CALENDAR_START).presence &&
            params.dig(filter_key, CALENDAR_END).presence &&
            super
        end

        def td_class_for(date)
          'calendar-month-day' if month_range.cover?(date)
        end

        private

        def filter_key = Ransack.options[:search_key]

        def alert_border_css_classes_for(resource, date)
          return %w[rounded-0 border-start-0 border-end-0] if siblings_resource_for?(resource, date)
          return %w[rounded-end border-start-0 me-2] if previous_resource_for?(resource, date)
          return %w[rounded-start border-end-0 ms-2] if next_resource_for?(resource, date)

          %w[rounded]
        end

        def end_date = end_of_month_date
          .end_of_week
          .to_date

        def end_of_month_date
          (calendar_start_date || resources.maximum(CALENDAR_START) || ::Date.current)
            .end_of_month
        end

        def month_range = start_of_month_date..end_of_month_date

        def next_resource_for?(resource, date)
          resources_for(date.tomorrow).include?(resource)
        end

        def siblings_resource_for?(resource, date)
          resources_for(date.yesterday).include?(resource) &&
            resources_for(date.tomorrow).include?(resource)
        end

        def start_date = start_of_month_date
          .beginning_of_week
          .to_date

        def start_of_month_date
          (calendar_start_date || resources.minimum(CALENDAR_START) || ::Date.current)
            .beginning_of_month
        end

        def calendar_start_date = params
          .dig(filter_key, CALENDAR_START, :gte)
          &.to_date
      end
    end
  end
end
