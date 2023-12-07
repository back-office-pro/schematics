# frozen_string_literal: true

module Schematics
  module Button
    module Comment
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :comments_feature_flag, to: ::Configuration, private: true
        delegate :icon, to: '::Comment.entity'
        option :resource

        def display_count
          count >= LIMIT ? "#{LIMIT.pred}+" : count
        end

        memoize def count = resource
          .comments
          .count

        def title = ::Comment
          .human_name_plural
          .humanize

        def render?
          comments_feature_flag && can?(:create, ::Comment)
        end
      end
    end
  end
end
