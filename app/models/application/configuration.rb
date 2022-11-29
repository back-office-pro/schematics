# frozen_string_literal: true

module Application
  module Configuration
    extend ActiveSupport::Concern

    prepended do
      after_update :set_chart_colors, if: :theme_color_previously_changed?
      after_update :set_default_locale, if: :locale_previously_changed?
      after_update :set_default_time_zone, if: :time_zone_previously_changed?
      attribute :company_name, default: -> { ::Tenant.human }
    end

    def palette = theme_color
      .dup
      .paint
      .palette
      .analogous(as: :hex)

    private

    def set_chart_colors
      Chartkick.options[:colors] = palette
    end

    def set_default_locale
      Rails.configuration.i18n.default_locale = locale
    end

    def set_default_time_zone
      Rails.configuration.time_zone = time_zone
    end
  end
end
