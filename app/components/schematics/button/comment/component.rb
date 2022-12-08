# frozen_string_literal: true

module Schematics
  module Button
    module Comment
      class Component < ApplicationComponent
        delegate :icon, to: 'mod::Comment.entity'
        delegate :size, to: 'resource.comments'
        option :resource

        def display_count
          size >= 10 ? '9+' : size
        end

        def render?
          config(:comments_feature_flag)
        end
      end
    end
  end
end
