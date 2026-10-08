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
  class CSVSerializer < CSVTemplateSerializer
    def initialize(resources, preferences)
      super(resources.first.class)
      @resources = resources
      @preferences = preferences
    end

    memoize def content
      generate do |file|
        @resources.each do |resource|
          file << line(resource)
        end
      end
    end

    private

    def elements = entity
      .listable_elements
      .select { @preferences.fetch("col_#{it.entity.id}_#{it.id}", true) }

    def line(resource)
      elements.stable_sort_by(&:weight).map do |element|
        Array(element.format(resource.public_send(element.name))).join(' ')
      end
    end
  end
end
