# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module JavascriptImportmap
    class Component < ApplicationComponent
      def entry_point
        return 'application' if application_file_exists?

        engine_application_path
      end

      def engine_application_path = 'schematics/application'

      def application_file_exists? = Rails
        .root
        .join('app/javascript/application.js')
        .exist?
    end
  end
end
