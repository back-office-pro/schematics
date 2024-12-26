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
        .tap { it.write(content_type) }
        .tap(&:rewind)

      memoize def read = File.read(file)

      memoize def base64_encoded = Base64.encode64(read)

      def data = ['data:', content_type, ';base64,', base64_encoded].join
    end
  end
end
