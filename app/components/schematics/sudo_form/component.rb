# frozen_string_literal: true

module Schematics
  module SudoForm
    class Component < ApplicationComponent
      delegate :bootstrap_form_with, to: :helpers

      def url = sudos_path

      def model = ::User.new
    end
  end
end
