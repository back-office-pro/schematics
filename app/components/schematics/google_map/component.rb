# frozen_string_literal: true

module Schematics
  module GoogleMap
    class Component < ApplicationComponent
      option :address, reader: false

      def url = "https://www.google.com/maps/embed/v1/place?q=#{address}&key=#{api_key}&zoom=6"

      private

      def address = CGI.escape(@address || ' ')

      def api_key = Engine
        .credentials
        .gcloud[:api_key]
    end
  end
end
