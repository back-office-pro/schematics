# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      class Chat
        include Interactor

        delegate :migration, to: :context, private: true
        delegate :prompt, to: :migration, private: true
        delegate :logger, :env, to: '::Rails', private: true
        delegate :openai_access_token,
                 :openai_uri_base,
                 :openai_model,
                 to: '::Configuration',
                 private: true

        after :log_data

        def call
          context.data = OpenAIMapper.new.call(responses).fetch(:data)
        end

        private

        memoize def client = ::OpenAI::Client.new(
          access_token: openai_access_token,
          uri_base: openai_uri_base,
          request_timeout: 240,
          log_errors: env.local?
        )

        memoize def responses = client.chat(parameters:)

        def parameters = {
          model: openai_model,
          temperature: 1,
          frequency_penalty: 0,
          presence_penalty: 0,
          tool_choice: 'required',
          tools: [
            type: 'function',
            function: {
              name: 'schema',
              parameters: ::OpenAI::StructuredOutput.new.to_h,
              strict: true
            }
          ],
          messages: [
            { role: 'system', content: I18n.t('migrations.openai.system') },
            { role: 'user', content: prompt }
          ]
        }

        def log_data = logger
          .tagged('OpenAI', openai_model)
          .info(context.data.to_json)
      end
    end
  end
end
