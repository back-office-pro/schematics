# frozen_string_literal: true

class Configuration < Schematics::ApplicationRecord
  LOCALE_TO_TIME_ZONE = { en: 'UTC', fr: 'Paris', it: 'Rome' }.freeze

  attribute :company_name, default: -> { Tenant.human }
  attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

  class << self
    def color_palette = theme_color
      .dup
      .paint
      .palette
      .analogous(as: :hex)
  end

  def time_zone
    super || LOCALE_TO_TIME_ZONE[locale&.to_sym]
  end
end
