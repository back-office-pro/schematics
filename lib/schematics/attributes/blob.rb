# frozen_string_literal: true

module Schematics
  module Attributes
    class Blob < Attachment
      def preload = { blob: :variant_records }
      def to_str = ''

      def search_data
        <<~RUBY
          #{name}: #{name}&.filename&.to_s
        RUBY
      end
    end
  end
end
