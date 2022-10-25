# frozen_string_literal: true

module Schematics
  module LinkPreview
    class Component < ApplicationComponent
      delegate :title, :favicon, :description, to: :object, allow_nil: true
      option :url

      def object
        @object ||= ::LinkThumbnailer.generate(url)
      rescue ::LinkThumbnailer::Exceptions
        nil
      end

      def render?
        url.present?
      end
    end
  end
end
