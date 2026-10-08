# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      module BrowserMissing
        class Component < Button::GenerateFileInBackground::Component
          option :text, default: -> { :download_pdf }
          option :extension, default: -> { :pdf }
        end
      end
    end
  end
end
