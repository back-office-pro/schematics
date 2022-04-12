# frozen_string_literal: true

module Schematics
  module PdfHeader
    class Component < ApplicationComponent
      def initialize(resource:)
        super
        @resource = resource
      end
    end
  end
end
