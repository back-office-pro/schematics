module Schematics
  module GoogleMap
    class Component < ApplicationComponent
      def initialize(address:)
        super
        @address = address
      end

      def url
        "https://www.google.com/maps/embed/v1/place?q=#{CGI.escape(@address)}&key=#{api_key}"
      end

      private

      def api_key
        Engine.credentials.gcloud[:api_key]
      end
    end
  end
end
