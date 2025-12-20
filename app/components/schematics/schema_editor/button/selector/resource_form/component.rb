# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module Selector
        module ResourceForm
          class Component < ApplicationComponent
            delegate :openai_access_token_with_fallback, to: '::Configuration', private: true

            def icon = :brain

            def title
              t('.missing_openai_access_token') unless openai_access_token_with_fallback
            end

            def css_classes = class_names(disabled: title.present?)
          end
        end
      end
    end
  end
end
