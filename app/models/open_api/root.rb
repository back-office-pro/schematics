# frozen_string_literal: true

module OpenAPI
  # :reek:Attribute
  class Root
    include ::ActiveModel::API
    attr_accessor :schema

    DEFAULT_TAGS = [
      'Message replies',
      'One time passwords',
      'Password resets',
      'Preferences',
      'Profile',
      'Sudos',
      'Tokens',
      'Versions'
    ].freeze

    def to_h = { openapi:, security:, tags:, paths:, components: }

    private

    def openapi = '3.1.1'

    def security = []

    def tags = schema
      .entities
      .flat_map(&method(:entity_paths))
      .compact
      .map(&:entity)
      .map(&:model_class)
      .map(&:human_name_plural)
      .map(&:humanize)
      .concat(DEFAULT_TAGS)
      .uniq
      .sort
      .map { |name| { name: } }

    def paths = schema
      .entities
      .flat_map(&method(:entity_paths))
      .filter_map(&:to_h)
      .reduce(&:deep_merge)
      .sort
      .to_h

    def entity_paths(entity) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      [
        (Paths::List.new(entity:) if entity.can?(:index)),
        (Paths::Autocomplete.new(entity:) if entity.can?(:index)),
        (Paths::Create.new(entity:) if entity.can?(:create)),
        (Paths::Duplicate.new(entity:) if entity.can?(:create)),
        (Paths::Import.new(entity:) if entity.can?(:create)),
        (Paths::Archive.new(entity:) if entity.can?(:archive)),
        (Paths::Restore.new(entity:) if entity.can?(:archive)),
        (Paths::Show.new(entity:) if entity.can?(:show)),
        (Paths::Comment.new(entity:) if entity.can?(:show)),
        (Paths::Update.new(entity:, http_method: :patch) if entity.can?(:update)),
        (Paths::Update.new(entity:, http_method: :put) if entity.can?(:update)),
        (Paths::Destroy.new(entity:) if entity.can?(:destroy)),
        *entity.events.map { |event| Paths::Trigger.new(entity:, event:) }
      ]
    end

    def components = {
      securitySchemes: {
        token: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        },
        api_key: {
          type: 'apiKey',
          name: 'x-api-key',
          in: 'header'
        }
      }
    }
  end
end
