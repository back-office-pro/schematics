# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Documentation < Schematics::ApplicationRecord
  attribute :app_version, default: -> { Migration.current_version }
  attribute :core_version, default: -> { Schematics::VERSION }

  class << self
    def create!(schema: nil, **)
      super(**default_data(schema), **)
    end

    private

    def default_data(schema)
      I18n
        .available_locales
        .map { |locale| { "data_#{locale}": OpenAPI::Root.new(**{ schema:, locale: }.compact) } }
        .reduce(&:merge)
        .transform_values(&:to_h)
        .transform_values(&:to_json)
    end
  end

  def data(**)
    JSON.parse(super, symbolize_names: true) if super
  end
end
