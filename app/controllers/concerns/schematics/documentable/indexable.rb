# frozen_string_literal: true

module Schematics
  module Documentable
    module Indexable
      extend ActiveSupport::Concern

      included do
        entity = model_class.entity
        api :index, "List #{entity.name.pluralize}" do
          query :page, ::Integer, desc: 'Page number'
          query :items, ::Integer, desc: 'Items per page'
          query :sort, ::String, desc: 'Sort fields list separated by comma'

          query "#{Ransack.options[:search_key]}[with_deleted]", 'boolean', desc: 'Display archives'

          entity.searchable_elements.each do |element|
            query "#{Ransack.options[:search_key]}[#{element.name}]",
                  element.open_api_type,
                  desc: "Filter by #{element.name}"
          end

          response 200, 'Success', :json, data: [
            entity
              .renderable_elements_without_has_many_associations
              .stable_sort_by(&:weight)
              .to_h { [_1.name, _1.open_api_type] }
          ]
          response 401, 'Not Authorized', :json
        end
      end
    end
  end
end
