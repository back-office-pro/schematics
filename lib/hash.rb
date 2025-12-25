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

class Hash
  # :reek:FeatureEnvy
  def deep_flatten(prefix = nil)
    each_pair
      .reduce({}) do |hash, (key, value)|
        case value
        when Hash
          hash.merge value.deep_flatten "#{prefix}#{key}_"
        else
          hash.merge "#{prefix}#{key}": value
        end
      end
  end

  # :reek:FeatureEnvy
  def flatten_to_nested(separator = '.')
    each_with_object({}) do |(key, value), all|
      key_parts = key.split(separator).map!(&:to_sym)
      leaf = key_parts[0...-1].reduce(all) { |acc, elem| acc[elem] ||= {} }
      leaf[key_parts.last] = value
    end
  end
end
