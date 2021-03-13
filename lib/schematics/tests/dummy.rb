require 'rack/test/uploaded_file'
require 'action_dispatch/http/mime_type'

module Schematics
  module Tests
    class Dummy
      def initialize(extension)
        @extension = extension
      end

      def default
        @default ||= Rack::Test::UploadedFile.new(file, content_type)
      end

      def json_default
        {
          'filename' => filename,
          'content_type' => content_type,
          'data' => data,
        }
      end

      private

      def file
        return @file if defined?(@file)
        @file = Tempfile.new(filename_array)
        @file.write(content_type)
        @file.rewind
        @file
      end

      def read
        @read ||= File.read(file)
      end

      def base64_encoded
        @base64_encoded ||= Base64.encode64(read)
      end

      def data
        ['data:', content_type, ';base64,', base64_encoded].join
      end

      def filename_array
        ['dummy', ".#{@extension}"]
      end

      def filename
        filename_array.join
      end

      def content_type
        Mime[@extension]
      end
    end
  end
end
