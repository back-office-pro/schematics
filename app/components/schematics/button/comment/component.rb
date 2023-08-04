# frozen_string_literal: true

module Schematics
  module Button
    module Comment
      class Component < ApplicationComponent
        delegate :comments_feature_flag, to: ::Configuration, private: true
        delegate :icon, to: '::Comment.entity'
        option :resource

        def display_count
          count >= 10 ? '9+' : count
        end

        memoize def count = resource
          .comments
          .count

        def render? = comments_feature_flag
      end
    end
  end
end
