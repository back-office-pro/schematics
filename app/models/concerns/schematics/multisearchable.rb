# frozen_string_literal: true

module Schematics
  module Multisearchable
    extend ActiveSupport::Concern

    included do
      include PgSearch::Model
      after_restore :update_pg_search_document
      multisearchable against: multisearchable_elements
    end

    class_methods do
      def multisearchable_elements = entity
        .multisearchable_elements
        .map(&:name)
        .map(&:to_sym)
    end
  end
end
