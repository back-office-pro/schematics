# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module CommentPreview
    class Component < ApplicationComponent
      delegate :content, :author, :created_at, to: :@comment
      with_collection_parameter :comment

      def initialize(comment:)
        super
        @comment = comment
      end
    end
  end
end
