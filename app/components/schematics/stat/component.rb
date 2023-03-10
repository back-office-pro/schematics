# frozen_string_literal: true

module Schematics
  module Stat
    class Component < ApplicationComponent
      delegate :icon, :value_formatted, :model_class, to: :@stat
      with_collection_parameter :stat

      def initialize(stat:)
        super
        @stat = stat
      end

      def render?
        can?(:show, @stat)
      end
    end
  end
end
