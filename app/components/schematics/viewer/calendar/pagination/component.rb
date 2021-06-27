# frozen_string_literal: true

module Schematics
  module Viewer
    module Calendar
      module Pagination
        class Component < ApplicationComponent
          delegate :month, :year, to: :start_date

          def initialize(entity:)
            super
            @entity = entity
          end

          def start_attribute
            @entity.datetime_attributes.first.name.to_sym
          end

          def end_attribute
            @entity.datetime_attributes.second.name.to_sym
          end

          def start_date
            params.dig(:filter, start_attribute, :gte)&.to_date || Date.current.beginning_of_month
          end

          def next_page_url
            url_for(params.to_unsafe_h.merge(next_page_filters))
          end

          def previous_page_url
            url_for(params.to_unsafe_h.merge(previous_page_filters))
          end

          private

          def next_page_filters
            {
              filter: {
                start_attribute => {
                  gte: start_date.end_of_month.tomorrow.beginning_of_month
                },
                end_attribute => {
                  lte: start_date.end_of_month.tomorrow.end_of_month
                }
              }
            }
          end

          def previous_page_filters
            {
              filter: {
                start_attribute => {
                  gte: start_date.yesterday.beginning_of_month
                },
                end_attribute => {
                  lte: start_date.yesterday.end_of_month
                }
              }
            }
          end
        end
      end
    end
  end
end
