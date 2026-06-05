# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Trackable
    extend ActiveSupport::Concern

    DENYLIST = %i[id created_at updated_at deleted_at lock_version slug].freeze

    included do
      has_paper_trail ignore: DENYLIST,
                      skip: hidden_attributes + filter_attributes,
                      on: %i[create update destroy],
                      version: :paper_trail_version,
                      versions: {
                        name: :paper_trail_versions,
                        class_name: 'Schematics::Version'
                      }

      has_many versions_association_name, # rubocop:disable Rails/HasManyOrHasOneDependent
               -> { unscope(where: :item_type).where(item_type: it.class.name) },
               class_name: version_class_name,
               as: :item
    end

    class_methods do
      private

      def hidden_attributes = entity
        .attributes
        .select(&:hidden?)
        .map(&:column_name)
        .map(&:to_sym)
    end

    def unstale
      self.lock_version += (self.class.finder(id).lock_version - lock_version)
      self
    end
  end
end
