# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module RichText
        class Component < Fields::Component
          delegate :rich_textarea, to: :form, private: true
          delegate :translated?, to: :field

          def required_rich_textarea(name, **)
            return rich_textarea(name, **) unless required?

            rich_textarea(name, **)
              .gsub(
                '<input type="hidden"',
                '<input type="text" required="required" class="trix-editor-hidden-input"'
              )
          end

          def data = { controller: 'mentions' }
        end
      end
    end
  end
end
