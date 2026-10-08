# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      class Component < ApplicationComponent
        delegate :active?, to: '::Configuration.license', private: true

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

        memoize def browser_missing?
          return false unless extension == :pdf
          return false if ENV['CHROMIUM_URL'].present?

          !Ferrum::Browser::Command.build(Ferrum::Browser::Options.new, nil)
        rescue Ferrum::BinaryNotFoundError
          true
        end

        def disabled?
          !active? && text == :download_as_csv
        end
      end
    end
  end
end
