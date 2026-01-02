# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'action_dispatch/http/mime_type'
require 'base64'
require 'rack/test/uploaded_file'

module Schematics
  module Specs
    class Dummy
      DEFAULT_EXTENSION = :png

      def initialize(extension)
        @extension = extension || DEFAULT_EXTENSION
      end

      memoize def default = Rack::Test::UploadedFile.new(file, content_type)

      def json_default = { filename:, content_type:, data: }.transform_keys(&:to_s)

      private

      def filename = filename_array.join

      def filename_array = ['dummy', ".#{@extension}"]

      def content_type = ::Mime[@extension].to_s

      memoize def file = Tempfile
        .new(filename_array)
        .tap { _1.write(content_type) }
        .tap(&:rewind)

      memoize def read = File.read(file)

      memoize def base64_encoded = Base64.encode64(read)

      def data = ['data:', content_type, ';base64,', base64_encoded].join
    end
  end
end
