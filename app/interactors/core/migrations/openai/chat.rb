# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      class Chat
        include Interactor

        delegate :migration, to: :context, private: true
        delegate :prompt, to: :migration, private: true
        delegate :business_sector, to: ::Subscription, private: true

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
                parameters: JSON.parse(json_schema, symbolize_names: true)
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

        def json_schema = ::ERB
          .new(File.read(json_schema_filepath))
          .result

        def json_schema_filepath
          File.expand_path('../../../../../lib/schema.json.erb', __dir__)
        end
      end
    end
  end
end
