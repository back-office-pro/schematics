# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module Selector
        module ResourceForm
          class Component < ApplicationComponent
            delegate :openai_configured?, to: '::Configuration', private: true

            def icon = :brain

            def title
              t('.missing_access_token') unless openai_configured?
            end

            def css_classes = class_names(disabled: !openai_configured?)
          end
        end
      end
    end
  end
end
