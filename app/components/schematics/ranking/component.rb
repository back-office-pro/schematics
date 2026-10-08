# frozen_string_literal: true

module Schematics
  module Ranking
    class Component < ApplicationComponent
      delegate :id, :icon, :entity_field_name, to: :@ranking
      with_collection_parameter :ranking

      def initialize(ranking:)
        super
        @ranking = ranking
      end

      def resources
        @ranking.resources(current_ability)
      end

      def field_name_formatted = :"#{entity_field_name}_formatted"

      def render?
        can?(:show, @ranking)
      end
    end
  end
end
