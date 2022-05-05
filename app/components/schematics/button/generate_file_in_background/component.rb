# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      class Component < ApplicationComponent
        class << self
          def csv_template(**kwargs)
            new(extension: :csv, icon: :file_csv, text: :download_csv_template, **kwargs)
          end

          def csv(**kwargs)
            new(extension: :csv, icon: :file_csv, text: :download_as_csv, **kwargs)
          end

          def pdf(**kwargs)
            new(extension: :pdf, icon: :file_pdf, text: :download_pdf, **kwargs)
          end
        end

        def initialize(extension:, icon:, text:, url: nil, dropdown: false)
          super
          @extension = extension
          @icon = icon
          @text = text
          @url = url
          @dropdown = dropdown
        end

        def action
          'click->generate-file-in-background#run' unless dropdown?
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
