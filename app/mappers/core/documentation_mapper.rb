# frozen_string_literal: true

module Core
  class DocumentationMapper < Dry::Transformer::Pipe
    import Dry::Transformer::HashTransformations
    import Dry::Transformer::Conditional

    tags = ::Tenant.schema.entities.reject(&:core?).map(&:class_name).map(&:pluralize)
    paths = ::Tenant.schema.entities.reject(&:core?).map(&:name).flat_map do |name|
      ::I18n.available_locales.map { |locale| ::I18n.t(name, scope: :routes, locale:).prepend('/') }
    end

    define! do
      unwrap :open_api
      guard -> { _1.key?(:core) } do
        map_value :tags, -> { _1.reject { |doc| tags.any? { |tag| doc[:name].eql?(tag) } } }
        map_value :paths, -> { _1.reject { |key| paths.any? { |path| key.starts_with?(path) } } }
      end
      guard -> { !_1.key?(:core) } do
        map_value :tags, -> { _1.reject { |doc| tags.none? { |tag| doc[:name].eql?(tag) } } }
        map_value :paths, -> { _1.reject { |key| paths.none? { |path| key.starts_with?(path) } } }
      end
      reject_keys [:core]
    end
  end
end
