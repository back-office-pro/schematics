# frozen_string_literal: true

module Schematics
  module Viewer
    module Calendar
      # :reek:DataClump
      class Component < Viewer::Component
        delegate :start_date_attribute_name,
                 :end_date_attribute_name,
                 to: :entity,
                 private: true

        def alert_css_classes_for(resource, date)
          %w[alert alert-secondary calendar text-truncate mb-1 p-2 rounded-0]
            .concat alert_border_css_classes_for(resource, date)
        end

        def date_range = (start_date..end_date).to_a

        def previous_resource_for?(resource, date)
          resources_for(date.yesterday).include?(resource)
        end

        def resources_for(date)
          resources.select do |resource|
            start_date = resource.public_send(start_date_attribute_name).beginning_of_day
            end_date = resource.public_send(end_date_attribute_name).end_of_day
            (start_date..end_date).cover?(date)
          end
        end

        def tbody_css_classes
          params.dig(filter_key, start_date_attribute_name).presence &&
            params.dig(filter_key, end_date_attribute_name).presence &&
            super
        end

        def td_class_for(date)
          'calendar-month-day' if month_range.cover?(date)
        end

        private

        def alert_border_css_classes_for(resource, date)
          return %w[rounded-0] if siblings_resource_for?(resource, date)
          return %w[rounded-end me-2] if previous_resource_for?(resource, date)
          return %w[rounded-start ms-2] if next_resource_for?(resource, date)

          %w[rounded]
        end

        def siblings_resource_for?(resource, date)
          resources_for(date.yesterday).include?(resource) &&
            resources_for(date.tomorrow).include?(resource)
        end

        def next_resource_for?(resource, date)
          resources_for(date.tomorrow).include?(resource)
        end

        def start_date = start_of_month_date
          .beginning_of_week
          .to_date

        def start_of_month_date
          (calendar_start_date || resources.minimum(start_date_attribute_name) || ::Date.current)
            .beginning_of_month
        end

        def calendar_start_date = params
          .dig(filter_key, start_date_attribute_name, :gte)
          &.to_date

        def filter_key = Ransack.options[:search_key]

        def end_date = end_of_month_date
          .end_of_week
          .to_date

        def end_of_month_date
          (calendar_start_date || resources.maximum(start_date_attribute_name) || ::Date.current)
            .end_of_month
        end

        def month_range = start_of_month_date..end_of_month_date
      end
    end
  end
end
