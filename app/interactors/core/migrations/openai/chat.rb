# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      class Chat
        include Interactor

        delegate :migration, to: :context, private: true
        delegate :prompt, :data_before_type_cast, to: :migration, private: true

        def call
          context.data = JSON.parse(response, symbolize_names: true)
        end

        private

        memoize def client = ::OpenAI::Client.new

        memoize def response
          client
            .chat(parameters:)
            .dig('choices', 0, 'message', 'content')
        rescue Faraday::Error
          JSON.parse(data_before_type_cast)
        end

        def parameters = {
          model: 'gpt-4o',
          temperature: 1,
          response_format: { type: 'json_object' },
          messages: [{ role: 'user', content: }]
        }

        def content = <<~TEXT
          Create a domain model for a construction web application.
          Properties and entity names should be in snake case.
          Generate the domain model in JSON format.
          Entity name should be in name key.
          Properties should be under attributes array.
          We only want belongs to associations.
          Associations are of type belongs_to.
          Only name and type keys are allowed.
          Each entity and properties should have an id which value is a random UUID.
        TEXT
      end
    end
  end
end
