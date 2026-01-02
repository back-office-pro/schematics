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
  class CSVTemplateSerializer
    delegate :entity, :human_name_plural, to: :@model_class, private: true

    def initialize(model_class)
      @model_class = model_class
    end

    memoize def content
      generate do |file|
        10.times { file << line }
      end
    end

    def content_type = ::Mime[extension].to_s

    def extension = :csv

    memoize def file = Tempfile
      .new
      .tap { _1.write(content) }
      .tap(&:rewind)

    def filename = "#{human_name_plural.parameterize}.#{extension}"

    protected

    def elements = entity
      .fillable_elements
      .grep_v(Associations::HasManyNested)

    def generate(col_sep: ',')
      CSV.generate(headers: true, col_sep:) do |file|
        file << headers
        yield file
      end
    end

    def headers = elements
      .stable_sort_by(&:weight)
      .map(&:name)
      .map(&method(:human_attribute_name))

    def line = ::Array.new(elements.size)

    def human_attribute_name(name)
      @model_class.human_attribute_name(name, count: 2)
    end
  end
end
