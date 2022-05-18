# frozen_string_literal: true

module Schematics
  module GoogleMap
    class Component < ApplicationComponent
      def initialize(address:)
        super
        @address = address
      end

      def render?
        @address.present?
      end

      def url = "https://www.google.com/maps/embed/v1/place?q=#{address}&key=#{api_key}"

      private

      def address = CGI.escape(@address)

      def api_key = settings(:google_cloud_api_key)
    end
  end
end
