# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SudoForm
    class Component < ApplicationComponent
      def url = sudos_path

      def model = ::User.new
    end
  end
end
