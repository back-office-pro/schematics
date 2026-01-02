# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Core
  module Migrations
    class CleanSearchIndexes
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_old_entities, to: :migration, private: true
      delegate :perform_all_later, to: '::ActiveJob', private: true

      progressable migration: 65

      def call = perform_all_later(
        migrator_old_entities
          .filter_map(&:class_name)
          .map { |searchable_type| Schematics::DestroySearchIndexJob.new(searchable_type:) }
      )
    end
  end
end
