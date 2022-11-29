# frozen_string_literal: true

module Application
  module Configuration
    extend ActiveSupport::Concern

    prepended do
      after_update :configure!
      attribute :company_name, default: -> { ::Tenant.human }
    end

    def configure!
      Chartkick.options[:colors] = palette
      Rails.configuration.i18n.default_locale = locale.to_sym
      Rails.configuration.time_zone = time_zone
    end

    def palette = theme_color
      .dup
      .paint
      .palette
      .analogous(as: :hex)
  end
end
