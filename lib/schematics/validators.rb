# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'action_view'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/enumerable'

module Schematics
  # :reek:Attribute
  class Validators
    include ::ActionView::Helpers::NumberHelper
    include ::ActiveModel::API

    delegate :==, :empty?, :any?, to: :compact_validators
    attr_accessor :name, :validators

    def compact_validators = validators
      .transform_values { it.try(:compact) || it }
      .compact_blank

    def merge(other_validators)
      validators.deep_merge!(other_validators)
      self
    end

    def rename_keys(hash)
      validators.transform_keys!(hash)
      self
    end

    def human(validators: compact_validators)
      validators
        .map(&method(:humanize))
        .each_with_object(' ')
        .map(&:join)
        .compact_blank
    end

    def to_str
      return '' if empty?

      <<~RUBY
        validates :#{name}, #{compact_validators}
      RUBY
    end

    private

    def humanize(key, value)
      [
        self.class.human_attribute_name(key, default: ''),
        case value
        when ::Array
          value.to_sentence
        when ::Hash
          human(validators: value)
        when ::Numeric
          number_to_human_size(value)
        when ::TrueClass
          nil
        else
          value.humanize
        end
      ].compact
    end
  end
end
