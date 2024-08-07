# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      class Chat
        include Interactor

        delegate :migration, to: :context, private: true
        delegate :prompt, to: :migration, private: true
        delegate :root, to: ::Schematics::Engine, private: true
        delegate :parse, to: ::ActiveSupport::ConfigurationFile, private: true

        def call
          context.data = responses.map(&method(:merge_uuids))
        end

        private

        memoize def client = ::OpenAI::Client.new

        memoize def responses = client
          .chat(parameters:)
          .dig('choices', 0, 'message', 'tool_calls')
          .map { _1.dig('function', 'arguments') }
          .map { JSON.parse(_1, symbolize_names: true) }

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
            { role: 'system', content: I18n.t('chat.system') },
            { role: 'user', content: prompt }
          ]
        }

        def merge_uuids(response)
          response[:id] = SecureRandom.uuid
          response[:attributes].each { _1.merge!(id: SecureRandom.uuid) }
          response
        end
      end
    end
  end
end
