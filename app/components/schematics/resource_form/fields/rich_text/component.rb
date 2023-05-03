# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module RichText
        class Component < Fields::Component
          delegate :translated?, to: :options, private: true
          delegate :rich_text_area, to: :form, private: true

          def required_rich_text_area(name, **options)
            return rich_text_area(name, **options) unless required?

            rich_text_area(name, **options)
              .gsub(
                '<input type="hidden"',
                '<input required="required" class="trix-editor-hidden-input"'
              )
          end

          def data = { controller: 'mentions' }
        end
      end
    end
  end
end
