# frozen_string_literal: true

module Schematics
  module Elasticsearchable
    extend ActiveSupport::Concern

    included do
      extend ::Pagy::Searchkick
      searchkick searchable: searchkick_elements,
                 filterable: searchkick_elements,
                 word_middle: searchkick_elements,
                 suggest: searchkick_elements,
                 callbacks: :async,
                 index_name:
    end

    class_methods do
      def index_name = -> { [Engine.tenant, model_name.plural, Rails.env].join('_') }

      def searchkick_elements = entity
        .searchable_elements
        .map(&:name)
        .map(&:to_sym)
    end
  end
end
