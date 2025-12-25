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

module Schematics
  module Sluggable
    extend ActiveSupport::Concern

    RESERVED_WORDS = %i[
      new
      edit
      delete
      archive
      restore
      revert
      autocompletions
      duplicate
      imports
      comparisons
      bulk_actions
      comments
      emailings
      replies
    ].freeze

    included do
      extend Mobility

      translates :slug,
                 type: :string,
                 column_fallback: false,
                 fallbacks: false

      extend FriendlyId

      friendly_id entity.descriptor.field_name || :to_param

      scope :with_string_translations, -> { includes(:string_translations) }
      scope :with_slugs, -> { includes(:slugs) }

      def should_generate_new_friendly_id? = true

      def normalize_friendly_id(value)
        value.to_s.parameterize(preserve_case: friendly_id_config.base.eql?(:to_param))
      end
    end
  end
end
