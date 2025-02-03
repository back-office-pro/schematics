# frozen_string_literal: true

class ::Documentation < Schematics::ApplicationRecord
  attribute :data, default: -> { OpenAPI::Root.new.to_h }
  attribute :app_version, default: -> { Migration.current_version }
  attribute :core_version, default: -> { Schematics::VERSION }

  #normalizes :data, with: -> { JSON.parse(it).symbolize_keys }

  class << self
    def create_with_default_data!(options = {})
      create!(**default_data, **options)
    end

    def default_data = I18n
      .available_locales
      .map { |locale| { :"data_#{locale}" => OpenAPI::Root.new(schema:, locale:) } }
      .reduce(&:merge)
      .transform_values(&:to_h)
      .transform_values(&:to_json)
  end
end
