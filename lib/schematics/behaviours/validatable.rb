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

require 'active_support/core_ext/module/delegation'

module Schematics
  module Behaviours
    module Validatable
      delegate :unique?, :required?, :case_insensitive?, to: :options

      def allow_blank = !required? # rubocop:disable Naming/PredicateMethod

      def available_options = [Options::Required]

      def validators = Schematics::Validators.new(
        name:,
        validators: {
          uniqueness_with_deleted: ({ case_sensitive: !case_insensitive?, allow_blank: } if unique?), # rubocop:disable Layout/LineLength
          presence: required?
        }
      )
    end
  end
end
