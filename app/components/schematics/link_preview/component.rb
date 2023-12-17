# frozen_string_literal: true

module Schematics
  module LinkPreview
    class Component < ApplicationComponent
      delegate :favicon, to: :object, allow_nil: true
      option :url

      memoize def object
        return if Rails.env.test?

        ::LinkThumbnailer.generate(url, http_open_timeout: 5, http_read_timeout: 5)
      rescue ::LinkThumbnailer::Exceptions
        nil
      end

      def title
        object&.title.presence || url
      end

      def render?
        url.present?
      end
    end
  end
end
