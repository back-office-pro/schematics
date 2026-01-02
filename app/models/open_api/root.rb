# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module OpenAPI
  # :reek:Attribute
  class Root
    include ::ActiveModel::API
    include ::ActiveModel::Attributes

    attribute :schema, default: -> { Schematics::Schema.new }
    attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

    def to_h
      ::I18n.with_locale(locale) do
        doc = open_api_data
        doc[:paths] = paths.deep_merge(doc[:paths]).sort.to_h
        doc[:tags] = tags.concat(doc[:tags]).sort { _1[:name] <=> _2[:name] } # rubocop:disable Style/NumberedParametersLimit
        doc
      end
    end

    private

    def open_api_data = ::YAML
      .load_file(open_api_data_path)
      .deep_symbolize_keys
      .dig(locale, :open_api)

    def open_api_data_path = Rails
      .root
      .join('config', 'locales', 'open_api', "#{locale}.yml")

    def paths = schema
      .entities
      .flat_map(&method(:entity_paths))
      .filter_map(&:to_h)
      .reduce(&:deep_merge)
      .to_h

    def tags = schema
      .entities
      .flat_map(&method(:entity_paths))
      .compact
      .map(&:tag)
      .uniq
      .map { |name| { name: } }

    def entity_paths(entity) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      [
        (Paths::Index.new(entity:) if entity.can?(:index)),
        (Paths::Autocomplete.new(entity:) if entity.can?(:index)),
        (Paths::Compare.new(entity:) if entity.can?(:index)),
        (Paths::Create.new(entity:) if entity.can?(:create)),
        (Paths::Duplicate.new(entity:) if entity.can?(:create)),
        (Paths::Import.new(entity:) if entity.can?(:create)),
        (Paths::Archive.new(entity:) if entity.can?(:archive)),
        (Paths::Restore.new(entity:) if entity.can?(:archive)),
        (Paths::BulkArchive.new(entity:) if entity.can?(:archive)),
        (Paths::Show.new(entity:) if entity.can?(:show)),
        (Paths::Comment.new(entity:) if entity.can?(:show)),
        (Paths::Forward.new(entity:) if entity.can?(:show)),
        (Paths::Update.new(entity:, http_method: :patch) if entity.can?(:update)),
        (Paths::Update.new(entity:, http_method: :put) if entity.can?(:update)),
        (Paths::Destroy.new(entity:) if entity.can?(:destroy)),
        *entity.events.map { |event| Paths::Trigger.new(entity:, event:) }
      ]
    end
  end
end
