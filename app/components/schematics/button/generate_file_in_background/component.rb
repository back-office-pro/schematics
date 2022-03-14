# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      class Component < ApplicationComponent
        class << self
          def csv(text, dropdown: false)
            new(content_type: ::Mime[:csv].to_s, icon: :file_csv, text:, dropdown:)
          end

          def pdf
            new(content_type: ::Mime[:pdf].to_s, icon: :file_pdf, text: :download_pdf)
          end
        end

        def initialize(content_type:, icon:, text:, dropdown: false)
          super
          @content_type = content_type
          @icon = icon
          @text = text
          @dropdown = dropdown
        end

        def action
          'click->generateFileInBackground#run' unless dropdown?
        end

        def toggle
          'dropdown' if dropdown?
        end

        def dropdown?
          @dropdown
        end
      end
    end
  end
end
