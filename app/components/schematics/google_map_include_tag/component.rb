# frozen_string_literal: true

module Schematics
  module GoogleMapIncludeTag
    class Component < ApplicationComponent
      def api_key = Engine
        .credentials
        .gcloud[:api_key]
    end
  end
end
