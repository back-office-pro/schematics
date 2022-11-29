# frozen_string_literal: true

module Schematics
  module Documentable # rubocop:disable Metrics/ModuleLength
    extend ActiveSupport::Concern

    included do
      include OpenApi::DSL
    end

    class_methods do
      def inherited(subclass) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
        super
        subclass.class_eval do
          route_base controller_path

          entity = model_class.entity

          if entity.can?(:index)
            api :index, "List #{entity.name.pluralize}" do
              query :page, ::Integer, desc: 'Page number'
              query :items, ::Integer, desc: 'Items per page'
              query 'filter[with_deleted]', 'boolean', desc: 'Display archives'

              entity.searchable_elements.each do |element|
                query "filter[#{element.name}]",
                      element.open_api_type,
                      desc: "Filter by #{element.name}"
              end

              response 200, 'Success', :json, data: [
                entity
                  .renderable_elements
                  .stable_sort_by(&:weight)
                  .excluding(entity.has_many_and_through_and_belongs_to_many_associations)
                  .map { [_1.name.camelize(:lower), _1.open_api_type] }
                  .to_h
              ]
              response 401, 'Not Authorized', :json
            end
          end

          if entity.can?(:create)
            api :create, "Create #{entity.name}" do
              entity.fillable_elements.each do |element|
                data "#{entity.name}[#{element.column_name}]",
                     element.open_api_type,
                     default: element.options.default,
                     required: element.required?
              end

              body :json, data: entity
                .fillable_elements
                .map { [_1.name, _1.open_api_type] }
                .to_h

              response 201, 'Success', :json
              response 401, 'Not Authorized', :json
              response 400, 'Bad Request', :json
              response 422, 'Unprocessable entity', :json
            end
          end

          if entity.can?(:update)
            api :update, "Update #{entity.name}" do
              path :id, ::String unless entity.is_a?(Entities::Singleton)

              entity.fillable_elements.each do |element|
                data "#{entity.name}[#{element.column_name}]",
                     element.open_api_type,
                     default: element.options.default,
                     required: element.required?
              end

              body :json, data: entity
                .fillable_elements
                .map { [_1.name, _1.open_api_type] }
                .to_h

              response 204, 'Success', :json
              response 401, 'Not Authorized', :json
              response 404, 'Not Found', :json
              response 400, 'Bad Request', :json
              response 422, 'Unprocessable entity', :json
            end
          end

          if entity.can?(:show)
            api :show, "Show #{entity.name}" do
              path :id, ::String unless entity.is_a?(Entities::Singleton)

              response 200, 'Success', :json, data: entity
                .renderable_elements
                .stable_sort_by(&:weight)
                .map { [_1.name.camelize(:lower), _1.open_api_type] }
                .to_h
              response 404, 'Not Found', :json
              response 401, 'Not Authorized', :json
            end
          end

          if entity.can?(:destroy)
            api :destroy, "Destroy #{entity.name}" do
              path :id, ::String

              response :no_content, 'Success', :json
              response 404, 'Not Found', :json
              response 401, 'Not Authorized', :json
            end
          end

          if entity.can?(:archive)
            api :archive, "Archive #{entity.name}" do
              path :id, ::String

              response :no_content, 'Success', :json
              response 404, 'Not Found', :json
              response 401, 'Not Authorized', :json
            end

            api :restore, "Restore #{entity.name}" do
              path :id, ::String

              response :no_content, 'Success', :json
              response 404, 'Not Found', :json
              response 401, 'Not Authorized', :json
            end
          end

          entity.events.each do
            api :trigger do
              path :id, ::String unless entity.is_a?(Entities::Singleton)

              response 204, 'Success', :json
              response 401, 'Not Authorized', :json
              response 404, 'Not Found', :json
            end
          end
        end
      end
    end
  end
end
