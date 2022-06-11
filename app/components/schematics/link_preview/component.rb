# frozen_string_literal: true

module Schematics
  module LinkPreview
    class Component < ApplicationComponent
      delegate :title, :favicon, :description, to: :object

      def initialize(url:)
        super
        @url = url
      end

      private

      def object
        @object ||= ::LinkThumbnailer.generate(@url)
      end
    end
  end
end
