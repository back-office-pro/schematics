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
  module Resources
    class Cache
      include Interactor

      delegate :resource, to: :context, private: true
      delegate :cache_key, to: :resource, private: true
      delegate :cached_attributes, to: 'resource.class', private: true

      def call = cached_attributes
        .select(&method(:changed?))
        .each(&method(:write_to_cache))

      private

      def changed?(attribute)
        resource.try("#{attribute}_previously_changed?")
      end

      def write_to_cache(attribute)
        Rails.cache.write("#{cache_key}/#{attribute}", resource.public_send(attribute))
      end
    end
  end
end
