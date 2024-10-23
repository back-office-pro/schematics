# frozen_string_literal: true

module Schematics
  module Ranking
    class Component < ApplicationComponent
      delegate :id, :icon, :values, to: :@ranking
      with_collection_parameter :ranking

      attr_reader :ranking

      def initialize(ranking:)
        super
        @ranking = ranking
      end

      def render?
        can?(:show, @ranking)
      end
    end
  end
end
