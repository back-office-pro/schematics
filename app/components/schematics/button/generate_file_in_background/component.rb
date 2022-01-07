# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      class Component < ApplicationComponent
        class << self
          def build_csv(url:, text:)
            new(content_type: 'text/csv', url:, icon: :file_csv, text:)
          end

          def build_pdf(url:)
            new(content_type: 'application/pdf', url:, icon: :file_pdf, text: :download_pdf)
          end
        end

        def initialize(content_type:, url:, icon:, text:)
          super
          @content_type = content_type
          @url = url
          @icon = icon
          @text = text
        end
      end
    end
  end
end
