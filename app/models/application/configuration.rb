# frozen_string_literal: true

module Application
  module Configuration
    extend ActiveSupport::Concern

    LOCALE_TO_TIME_ZONE = { fr: 'Paris', en: 'UTC' }.freeze

    prepended do
      after_initialize :set_chartkick_options
      attribute :company_name, default: -> { ::Tenant.human }
    end

    def time_zone
      super || LOCALE_TO_TIME_ZONE[locale.to_sym]
    end

    private

    def set_chartkick_options = ::Chartkick
      .options
      .merge!(colors:, empty:)

    def colors = theme_color
      .dup
      .paint
      .palette
      .analogous(as: :hex)

    def empty = ::I18n.t('schematics.application.resource.empty', locale:)
  end
end
