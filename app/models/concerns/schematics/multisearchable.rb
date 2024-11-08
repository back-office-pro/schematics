# frozen_string_literal: true

module Schematics
  module Multisearchable
    extend ActiveSupport::Concern

    included do
      include PgSearch::Model
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
