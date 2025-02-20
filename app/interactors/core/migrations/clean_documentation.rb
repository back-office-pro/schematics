# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class CleanDocumentation
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :version, to: :migration, private: true

      progressable migration: 80

      def call
        ::Documentation.delete_by(app_version: version)
      end
    end
  end
end
