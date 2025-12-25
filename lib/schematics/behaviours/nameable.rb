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

require 'active_record'
require 'active_record/attribute_methods'
require 'active_support/concern'

module Schematics
  module Behaviours
    # :reek:Attribute
    module Nameable
      extend ActiveSupport::Concern

      NAME_REGEX = %r{\A([a-z_/]+)\z}
      NAME_DENYLIST = %w[
        aasm
        aasm_read_state
        aasm_write_state
        aasm_write_state_without_persistence
        as_json
        associations
        attribute_formatted
        authenticate
        cached_serialized_json
        changed_link_preview_urls
        create_search_index
        create_search_index_async
        destroy_search_index
        destroy_search_index_async
        destroy_without_paranoia
        friendly_id
        friendly_id_config
        generate_link_previews
        interpolate
        interpolation_errors
        liquid_template
        normalize_friendly_id
        notify_mentions
        otp_after_column_name
        otp_backup_codes_column_name
        otp_backup_codes_count
        otp_column_name
        otp_counter_based
        otp_counter_column_name
        otp_digits
        otp_interval
        otp_one_time_backup_codes
        paper_trail
        paper_trail_event
        paper_trail_options
        paper_trail_version
        paper_trail_versions
        paranoia_column
        paranoia_sentinel_value
        really_delete
        rebuild_search_index
        rebuild_search_index_async
        rich_text_mentions
        search_index_content
        serialized_json
        slug
        slugs
        to_param
        to_s
        unstale
        version_association_name
        version_class_name
        versions_association_name
      ].freeze

      attr_accessor :name

      included do
        validates :name,
                  presence: true,
                  format: { with: NAME_REGEX, message: :name },
                  length: { maximum: 50 },
                  exclusion: { in: :dangerous_attribute_methods, message: :dangerous_attribute }
      end

      # :reek:UtilityFunction
      def dangerous_attribute_methods = ::ActiveRecord::AttributeMethods
        .dangerous_attribute_methods
        .dup
        .merge(self.class::NAME_DENYLIST)
    end
  end
end
