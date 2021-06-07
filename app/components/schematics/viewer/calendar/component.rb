# frozen_string_literal: true

module Schematics
  module Viewer
    module Calendar
      class Component < Viewer::Component
        def start_attribute
          entity.datetime_attributes.first.name.to_sym
        end

        def end_attribute
          entity.datetime_attributes.second.name.to_sym
        end

        def date_range
          (start_date.beginning_of_week..start_date.end_of_month.end_of_week).to_a
        end

        def start_date
          params.dig(:filter, start_attribute, :gte)&.to_date || Date.current.beginning_of_month
        end

        def td_classes_for(date)
          classes = ['day']
          classes << 'bg-light' if start_date.month != date.month && date < start_date
          classes << 'bg-light' if start_date.month != date.month && date > start_date
          classes
        end

        def resources_for(date)
          @resources.filter do |resource|
            resource.send(start_attribute).to_date <= date &&
              resource.send(end_attribute).to_date >= date
          end
        end
      end
    end
  end
end
