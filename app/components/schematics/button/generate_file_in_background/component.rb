# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      class Component < ApplicationComponent
        option :extension
        option :text
        option :url, optional: true
        option :dropdown, default: -> { false }

        class << self
          def csv_template(**)
            new(extension: :csv, text: :download_csv_template, **)
          end

          def csv(**)
            new(extension: :csv, text: :download_as_csv, **)
          end

          def pdf(**)
            new(extension: :pdf, text: :download_pdf, **)
          end
        end

        def title = t(".#{text}")

        def action
          'click->generate-file-in-background#run' unless dropdown?
        end

        def dropdown? = dropdown

        def icon = :"file_#{extension}"

        def toggle
          'dropdown' if dropdown?
        end
      end
    end
  end
end
