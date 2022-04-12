# frozen_string_literal: true

module Schematics
  module ChartPlaceholder
    class Component < ApplicationComponent
      def to_html
        render_in(view_context)
      end

      private

      def view_context
        ActionView::Base.new(lookup_context, {}, nil)
      end

      def lookup_context
        ActionView::LookupContext.new(ActionController::Base.view_paths)
      end
    end
  end
end
