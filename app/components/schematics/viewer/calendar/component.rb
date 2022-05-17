# frozen_string_literal: true

module Schematics
  module Viewer
    module Calendar
      class Component < Viewer::Component
        def date_range
          (start_date..end_date).to_a
        end

        def td_class_for(date)
          'calendar-month-day' if month_range.cover?(date)
        end

        def alert_css_classes_for(resource, date)
          %w[alert alert-secondary calendar lh-lg text-truncate mb-1 p-2]
            .concat alert_border_css_classes_for(resource, date)
        end

        def resources_for(date)
          @resources.select do |resource|
            start_date = resource.public_send(calendar_start_attribute).beginning_of_day
            end_date = resource.public_send(calendar_end_attribute).end_of_day
            (start_date..end_date).cover?(date)
          end
        end

        def tbody_css_classes
          params.dig(:filter, calendar_start_attribute).presence &&
            params.dig(:filter, calendar_end_attribute).presence &&
            super
        end

        def previous_resource_for?(resource, date)
          resources_for(date.yesterday).include?(resource)
        end

        private

        def start_date
          start_of_month_date
            .beginning_of_week
            .to_date
        end

        def end_date
          end_of_month_date
            .end_of_week
            .to_date
        end

        def month_range
          start_of_month_date..end_of_month_date
        end

        def start_of_month_date
          (calendar_start_date || @resources.map(&calendar_start_attribute).min || ::Date.current)
            .beginning_of_month
        end

        def end_of_month_date
          (calendar_start_date || @resources.map(&calendar_start_attribute).max || ::Date.current)
            .end_of_month
        end

        def next_resource_for?(resource, date)
          resources_for(date.tomorrow).include?(resource)
        end

        def siblings_resource_for?(resource, date)
          resources_for(date.yesterday).include?(resource) &&
            resources_for(date.tomorrow).include?(resource)
        end

        def alert_border_css_classes_for(resource, date)
          return %w[rounded-0 border-start-0 border-end-0] if siblings_resource_for?(resource, date)
          return %w[rounded-end border-start-0 me-2] if previous_resource_for?(resource, date)
          return %w[rounded-start border-end-0 ms-2] if next_resource_for?(resource, date)
        end
      end
    end
  end
end
