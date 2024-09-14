# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      module ChatGPT
        class Chat
          include Interactor

          delegate :migration, to: :context, private: true
          delegate :prompt, to: :migration, private: true
          delegate :logger, to: ::Rails, private: true
          delegate :root, to: ::Schematics::Engine, private: true
          delegate :parse, to: ::ActiveSupport::ConfigurationFile, private: true

          after :log_data

          def call
            context.data = OpenAiMapper.new.call(responses).fetch(:data)
          end

          private

          memoize def client = ::OpenAI::Client.new

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
