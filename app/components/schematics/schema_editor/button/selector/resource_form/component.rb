# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module Selector
        module ResourceForm
          class Component < ApplicationComponent
            delegate :openai_access_token_with_fallback, to: '::Configuration', private: true
            delegate :quota_prompts_exceeded?, to: '::Subscription', private: true

            def icon = :brain

            def title
              return t('.missing_openai_access_token') unless openai_access_token_with_fallback

              t('.quota_prompts_exceeded') if quota_prompts_exceeded?
            end

            def css_classes = class_names(disabled: title.present?)
          end
        end
      end
    end
  end
end
