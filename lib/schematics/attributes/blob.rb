# frozen_string_literal: true

module Schematics
  module Attributes
    class Blob < Attachment
      def preload = { blob: :variant_records }

      def search_data = <<~RUBY
        #{name}: #{name}&.filename&.to_s
      RUBY

      def to_str = ''
    end
  end
end
