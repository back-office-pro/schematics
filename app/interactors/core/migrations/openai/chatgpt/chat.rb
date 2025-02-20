# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      module ChatGPT
        class Chat
          include Interactor

          delegate :migration, to: :context, private: true
          delegate :prompt, to: :migration, private: true
          delegate :logger, :env, to: '::Rails', private: true
          delegate :root, to: '::Schematics::Engine', private: true
          delegate :parse, to: '::ActiveSupport::ConfigurationFile', private: true
          delegate :openai_access_token_with_fallback, to: '::Configuration', private: true

          after :log_data

          def call
            context.data = OpenAiMapper.new.call(responses).fetch(:data)
          end

          private

          memoize def client = ::OpenAI::Client.new(
            access_token: openai_access_token_with_fallback,
            request_timeout: 240,
            log_errors: env.local?
          )

          memoize def responses = client.chat(parameters:)

          def parameters = {
            model: 'gpt-4o-2024-08-06',
            temperature: 1,
            frequency_penalty: 0,
            presence_penalty: 0,
            tool_choice: 'required',
            tools: [
              {
                type: 'function',
                function: {
                  name: 'schema',
                  parameters: parse(root.join('lib', 'schema.yml')),
                  strict: true
                }
              }
            ],
            messages: [
              { role: 'system', content: I18n.t('migrations.openai.chatgpt.system') },
              { role: 'user', content: prompt }
            ]
          }

          def log_data = logger
            .tagged('OpenAI', 'ChatGPT')
            .info(context.data.to_json)
        end
      end
    end
  end
end
