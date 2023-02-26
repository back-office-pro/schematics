# frozen_string_literal: true

module Schematics
  module ApplicationStylesheetLink
    class Component < ApplicationComponent
      def render? = Rails
        .root
        .join('app/assets/stylesheets/application.css')
        .exist?
    end
  end
end
