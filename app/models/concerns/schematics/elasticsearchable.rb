# frozen_string_literal: true

module Schematics
  module Elasticsearchable
    extend ActiveSupport::Concern

    included do
      extend Pagy::Searchkick
      searchkick searchable: searchkick_elements,
                 filterable: searchkick_elements,
                 word_middle: searchkick_elements,
                 suggest: searchkick_elements,
                 callbacks: :async
    end

    class_methods do
      def searchkick_elements
        entity
          .searchable_elements
          .map(&:name)
          .map(&:to_sym)
      end
    end
  end
end
