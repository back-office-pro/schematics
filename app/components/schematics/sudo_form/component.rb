# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SudoForm
    class Component < ApplicationComponent
      delegate :root_path, :sudos_path, to: 'Schematics::Engine.routes.url_helpers'

      def url = sudos_path

      def model = ::User.new
    end
  end
end
