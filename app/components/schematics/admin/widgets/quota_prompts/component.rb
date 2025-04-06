# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module QuotaPrompts
        class Component < ApplicationComponent
          delegate :openai_access_token, to: '::Configuration', private: true
          delegate :quota_prompts, to: '::Subscription'

          def icon = :brain

          def title = t('.title')

          def prompts_count = ::Rails
            .cache
            .fetch('prompts')
            .to_i

          def percentage
            prompts_count * 100 / quota_prompts
          end

          def background_css_class
            return 'bg-danger' if prompts_count >= quota_prompts

            'bg-success'
          end

          def render?
            can?(:cancel, ::Subscription) && !openai_access_token
          end
        end
      end
    end
  end
end
