# Copyright © 2025 Dev & Software. All rights reserved.
#
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
    class RebuildSearchIndexes
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_new_and_changed_entities, to: :migration, private: true
      delegate :perform_all_later, to: '::ActiveJob', private: true

      progressable migration: 80

      def call = perform_all_later(
        migrator_new_and_changed_entities
          .filter_map(&:model_class)
          .map(&Schematics::RebuildSearchIndexJob.method(:new))
      )
    end
  end
end
