# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Comment
      class Component < ApplicationComponent
        LIMIT = 10
        delegate :comments_feature_flag, to: 'current_module::Configuration', private: true
        delegate :icon, to: 'current_module::Comment.entity'
        option :resource

        def display_count
          count >= LIMIT ? "#{LIMIT.pred}+" : count
        end

        memoize def count = resource
          .record_comments
          .count

        def title = current_module::Comment
          .human_name_plural
          .humanize

        def render?
          comments_feature_flag &&
            can?(:create, current_module::Comment) &&
            can?(:comment, resource.class)
        end
      end
    end
  end
end
