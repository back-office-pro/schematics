# frozen_string_literal: true

module Schematics
  module Attributes
    class Blob < Attachment
      def preload
        { blob: :variant_records }
      end

      def search_data
        <<~RUBY
          #{name}&.filename&.to_s
        RUBY
      end

      def to_str
        ''
      end
    end
  end
end
