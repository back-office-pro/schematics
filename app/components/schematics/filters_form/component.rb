# frozen_string_literal: true

module Schematics
  module FiltersForm
    class Component < ApplicationComponent
      option :model_class

      def url = resources_path(model_class)

      def method = :get

      def id = 'filters'

      def data = { turbo_frame: 'viewer', controller: 'filters' }

      def css_classes = %w[animate__animated animate__zoomIn]

      def query_params = %i[sort limit month_page]
    end
  end
end
