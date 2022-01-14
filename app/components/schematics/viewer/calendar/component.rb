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

        def start_date
          (calendar_start_date || @resources.map(&calendar_start_attribute).min || Date.current)
            .beginning_of_month
            .beginning_of_week
            .to_date
        end

        def end_date
          (calendar_start_date || @resources.map(&calendar_start_attribute).max || Date.current)
            .end_of_month
            .end_of_week
            .to_date
        end

        def td_classes_for(date)
          classes = ['day']
          classes << 'bg-light' if start_date.month != date.month && date < start_date
          classes << 'bg-light' if start_date.month != date.month && date > start_date
          classes
        end

        def resources_for(date)
          @resources.filter do |resource|
            resource.public_send(calendar_start_attribute).to_date <= date &&
              resource.public_send(calendar_end_attribute).to_date >= date
          end
        end

        def tbody_css_classes
          params.dig(:filter, calendar_start_attribute).present? &&
            params.dig(:filter, calendar_end_attribute).present? &&
            super
        end
      end
    end
  end
end
