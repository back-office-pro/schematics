# frozen_string_literal: true

class Configuration < Schematics::ApplicationRecord
  LOCALE_TO_TIME_ZONE = { fr: 'Paris', en: 'UTC' }.freeze

  after_initialize :set_chartkick_options
  attribute :company_name, default: -> { Tenant.human }
  attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

  class << self
    def method_missing(method_name, *, &)
      return super if cached_attributes.exclude?(method_name)

      Rails.cache.fetch("configuration/#{method_name}") { instance.public_send(method_name) }
    end

    def respond_to_missing?(method_name, *)
      cached_attributes.include?(method_name) || super
    end
  end

  def time_zone
    super || LOCALE_TO_TIME_ZONE[locale&.to_sym]
  end

  private

  def set_chartkick_options = Chartkick
    .options
    .merge!(colors:, empty:)

  def colors = theme_color
    .dup
    .paint
    .palette
    .analogous(as: :hex)

  def empty = I18n.t('schematics.application.resource.empty', locale:)
end
