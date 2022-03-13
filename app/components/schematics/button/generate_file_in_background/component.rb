# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      class Component < ApplicationComponent
        class << self
          def csv(text)
            new(content_type: ::Mime[:csv].to_s, icon: :file_csv, text:)
          end

          def pdf
            new(content_type: ::Mime[:pdf].to_s, icon: :file_pdf, text: :download_pdf)
          end
        end

        def initialize(content_type:, icon:, text:)
          super
          @content_type = content_type
          @icon = icon
          @text = text
        end
      end
    end
  end
end
