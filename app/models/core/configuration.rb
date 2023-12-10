# frozen_string_literal: true

class Configuration < Schematics::ApplicationRecord
  LOCALE_TO_TIME_ZONE = { en: 'UTC', fr: 'Paris', it: 'Rome' }.freeze

  after_initialize :set_chartkick_options
  after_update :set_chartkick_options

  attribute :company_name, default: -> { Tenant.human }
  attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

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
