# frozen_string_literal: true

module Schematics
  module BlogSearch
    class Component < Filter::Component
      delegate :blog_index_path, to: 'Schematics::Engine.routes.url_helpers'

      def url = blog_index_path

      def placeholder = t('.placeholder')
    end
  end
end
