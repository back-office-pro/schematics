# frozen_string_literal: true

module Schematics
  module Stat
    class Component < ApplicationComponent
      delegate :id,
               :icon,
               :value,
               :threshold,
               :exceeded?,
               :value_formatted,
               :model_class,
               to: :@stat
      with_collection_parameter :stat

      def initialize(stat:)
        super
        @stat = stat
      end

      def background_css_class
        return 'bg-danger' if exceeded?

        'bg-success'
      end

      def percentage
        value * 100 / threshold
      end

      def render?
        can?(:show, @stat)
      end
    end
  end
end
