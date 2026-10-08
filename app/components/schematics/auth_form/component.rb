# frozen_string_literal: true

module Schematics
  module AuthForm
    class Component < ApplicationComponent
      delegate :bootstrap_form_with, to: :helpers

      def url = resources_path(::Session)

      def scope = :session

      def model = ::User.new
    end
  end
end
