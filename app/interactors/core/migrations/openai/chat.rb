# frozen_string_literal: true

module Core
  module Migrations
    module OpenAI
      class Chat
        include Interactor

        delegate :migration, to: :context, private: true
        delegate :prompt, :data_before_type_cast, to: :migration, private: true
        delegate :business_sector, to: ::Subscription, private: true
        delegate :collection,
                 to: Schematics::Options::Icon,
                 prefix: :icons,
                 private: true
        delegate :collection,
                 to: Schematics::Attributes::Attribute,
                 prefix: :attributes,
                 private: true

        def call
          context.data = responses
        end

        private

        memoize def client = ::OpenAI::Client.new

        memoize def responses
          client
            .chat(parameters:)
            .dig('choices', 0, 'message', 'tool_calls')
            .map { _1.dig('function', 'arguments') }
            .map { JSON.parse(_1, symbolize_names: true) }
        rescue Faraday::Error
          JSON.parse(data_before_type_cast)
        end

        def parameters = {
          model: 'gpt-4o',
          temperature: 1,
          tools: [{ type: 'function', function: }],
          messages: [
            {
              role: 'user',
              content: "Create a domain model for a #{business_sector} web application"
            },
            prompt && { role: 'user', content: prompt }
          ].compact
        }

        def function = {
          name: 'domainModel',
          parameters: {
            type: 'object',
            properties: {
              id: {
                type: 'string',
                pattern: '\w{8}-\w{4}-\w{4}-\w{4}-\w{12}',
                description: 'A random RFC 4122 UUID'
              },
              name: {
                type: 'string',
                description: 'The entity name in snake case',
                not: { enum: denied_entity_names }
              },
              options: {
                type: 'object',
                properties: {
                  descriptor: {
                    type: 'string',
                    description: 'The property name which represents the most the entity'
                  },
                  icon: {
                    type: 'string',
                    enum: icons_collection,
                    description: 'An icon which represents the entity in snake case'
                  }
                }
              },
              attributes: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: {
                      type: 'string',
                      pattern: '\w{8}-\w{4}-\w{4}-\w{4}-\w{12}',
                      description: 'A random RFC 4122 UUID'
                    },
                    name: {
                      type: 'string',
                      pattern: '.*(?<!_id)$',
                      description: 'The property name in snake case',
                      not: { enum: denied_attribute_names }
                    },
                    type: {
                      type: 'string',
                      enum: allowed_attribute_types,
                      description: 'The property type in snake case'
                    }
                  },
                  required: %w[id name type]
                }
              }
            },
            required: %w[id name options attributes]
          }
        }

        def denied_attribute_names = ::ActiveRecord::AttributeMethods
          .dangerous_attribute_methods
          .dup
          .merge(Schematics::Behaviours::Nameable::NAME_DENYLIST)
          .merge(Schematics::Trackable::DENYLIST)
          .to_a

        def denied_entity_names = migration
          .data
          .entities
          .select(&:core?)
          .map(&:name)
          .concat(Schematics::Entities::Entity::NAME_DENYLIST)

        def allowed_attribute_types = Schematics::Attributes::Attribute
          .collection
          .map(&:name)
          .map(&:demodulize)
          .map(&:underscore)
      end
    end
  end
end
