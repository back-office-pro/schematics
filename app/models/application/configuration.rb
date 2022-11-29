# frozen_string_literal: true

module Application
  module Configuration
    extend ActiveSupport::Concern

    prepended do
      after_update -> { Chartkick.options[:colors] = palette }, if: :theme_color_previously_changed?
      attribute :company_name, default: -> { ::Tenant.human }
      attribute :theme_color, default: -> { Rails.configuration.theme_color }
      attribute :time_zone, default: -> { Rails.configuration.time_zone }
      attribute :locale, default: -> { Rails.configuration.i18n.default_locale }
    end

    def palette = theme_color
      .dup
      .paint
      .palette
      .analogous(as: :hex)
  end
end
