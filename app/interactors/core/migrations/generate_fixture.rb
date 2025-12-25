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
    class GenerateFixture
      include Schematics::Progressable

      delegate :migration, to: :context, private: true

      progressable migration: 100

      def call
        ::ActiveStorage::Blob.find_by(key:).try(:purge)
        ::ActiveStorage::Blob.create_and_upload!(key:, filename:, content_type:, io:)
      end

      private

      def key = File.join('backups', filename)

      def filename = 'migration.json'

      def content_type = ::Mime[:json].to_s

      def io = Tempfile
        .new
        .tap { _1.write(migration.data.to_json) }
        .tap(&:rewind)
    end
  end
end
