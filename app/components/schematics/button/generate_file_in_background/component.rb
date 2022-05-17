# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      class Component < ApplicationComponent
        class << self
          def csv_template(**kwargs)
            new(extension: :csv, text: :download_csv_template, **kwargs)
          end

          def csv(**kwargs)
            new(extension: :csv, text: :download_as_csv, **kwargs)
          end

          def pdf(**kwargs)
            new(extension: :pdf, text: :download_pdf, **kwargs)
          end
        end

        def initialize(extension:, text:, url: nil, dropdown: false)
          super
          @extension = extension
          @text = text
          @url = url
          @dropdown = dropdown
        end

        def action
          'click->generate-file-in-background#run' unless dropdown?
        end

        def dropdown? = @dropdown

        def icon = :"file_#{@extension}"

        def toggle
          'dropdown' if dropdown?
        end
      end
    end
  end
end
