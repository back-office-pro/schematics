# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      class Chat
        include Interactor

        delegate :migration, to: :context, private: true
        delegate :prompt, to: :migration, allow_nil: true, private: true
        delegate :business_sector, to: ::Subscription, private: true
        delegate :root, to: ::Schematics::Engine, private: true
        delegate :parse, to: ::ActiveSupport::ConfigurationFile, private: true

        def call
          context.data = responses
        end

        private

        memoize def client = ::OpenAI::Client.new

        memoize def responses = client
          .chat(parameters:)
          .dig('choices', 0, 'message', 'tool_calls')
          .map { _1.dig('function', 'arguments') }
          .map { JSON.parse(_1, symbolize_names: true) }

        def parameters = {
          model: 'gpt-4o',
          temperature: 1,
          frequency_penalty: 0,
          presence_penalty: 0,
          tools: [
            {
              type: 'function',
              function: {
                name: 'domainModel',
                parameters: parse(root.join('lib', 'schema.yml'))
              }
            }
          ],
          messages: [
            {
              role: 'user',
              content: "Create a domain model for a #{business_sector} web application"
            },
            prompt && { role: 'user', content: prompt }
          ].compact
        }
      end
    end
  end
end
