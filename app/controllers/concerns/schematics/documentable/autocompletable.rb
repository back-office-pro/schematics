# frozen_string_literal: true

module Schematics
  module Documentable
    module Autocompletable
      extend ActiveSupport::Concern

      included do
        entity = model_class.entity
        api :autocomplete, "Autocomplete #{entity.name.pluralize}" do
          query :field, ::String, desc: 'Field to autocomplete'

          entity.searchable_elements.each do |element|
            query "#{Ransack.options[:search_key]}[#{element.name}]",
                  element.open_api_filter_type,
                  desc: "Filter by #{element.name}"
          end

          response 200, 'Success', :json, data: [::String]
          response 400, 'Bad Request', :json
          response 401, 'Not Authorized', :json
        end
      end
    end
  end
end
