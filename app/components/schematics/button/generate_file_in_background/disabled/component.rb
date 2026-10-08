# frozen_string_literal: true

module Schematics
  module Button
    module GenerateFileInBackground
      module Disabled
        class Component < Button::GenerateFileInBackground::Component
          option :text, default: -> { :download_as_csv }
          option :extension, default: -> { :csv }
        end
      end
    end
  end
end
