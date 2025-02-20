# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Ranking
    class Component < ApplicationComponent
      delegate :id, :icon, :field_name_formatted, to: :@ranking
      with_collection_parameter :ranking

      def initialize(ranking:)
        super
        @ranking = ranking
      end

      def resources
        @ranking.resources(current_ability)
      end

      def render?
        can?(:show, @ranking)
      end
    end
  end
end
