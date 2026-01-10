# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      class Chat
        include Interactor

        delegate :migration, to: :context, private: true
        delegate :prompt, to: :migration, private: true
        delegate :logger, :env, to: '::Rails', private: true
        delegate :structured_output_schema, to: '::OpenAI', private: true
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
            {
              type: 'function',
              function: {
                name: 'schema',
                parameters: structured_output_schema,
                strict: true
              }
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
