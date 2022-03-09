# frozen_string_literal: true

module Schematics
  module Viewer
    module Calendar
      class Component < Viewer::Component
        delegate :calendar_start_attribute,
                 :calendar_end_attribute,
                 :calendar_start_date,
                 :calendar_end_date,
                 to: :helpers

        def date_range
          (start_date..end_date).to_a
        end

        def td_class_for(date)
          'bg-light' if month_range.cover?(date)
        end

        def resources_for(date)
          @resources.filter do |resource|
            start_date = resource.public_send(calendar_start_attribute).beginning_of_day
            end_date = resource.public_send(calendar_end_attribute).end_of_day
            (start_date..end_date).cover?(date)
          end
        end

        def tbody_css_classes
          params.dig(:filter, calendar_start_attribute).present? &&
            params.dig(:filter, calendar_end_attribute).present? &&
            super
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
          (calendar_start_date || @resources.map(&calendar_start_attribute).min || Date.current)
            .beginning_of_month
        end

        def end_of_month_date
          (calendar_start_date || @resources.map(&calendar_start_attribute).max || Date.current)
            .end_of_month
        end
      end
    end
  end
end
