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
  module Imports
    class InsertData
      include Schematics::Progressable

      delegate :import, :data, :fail!, to: :context, private: true
      delegate :model_class, :model, :author, to: :import, private: true
      delegate :human_attribute_name,
               :insert_all,
               :generate_ulid,
               to: :model_class,
               private: true

      progressable import: 100

      def call
        record_ids = insert_all(data).pluck('id') # rubocop:disable Rails/SkipsModelValidations
        Schematics::Version.insert_all(record_ids.map(&method(:paper_trail_version))) # rubocop:disable Rails/SkipsModelValidations
      end

      private

      def paper_trail_version(id)
        {
          id: generate_ulid,
          item_type: model,
          item_id: id,
          event: 'import',
          whodunnit: author.id,
          created_at: ::Time.current
        }
      end
    end
  end
end
