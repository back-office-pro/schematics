# frozen_string_literal: true

module Application
  module Configuration
    extend ActiveSupport::Concern

    prepended do
      after_initialize :set_chartkick_options
      attribute :company_name, default: -> { tenant.human }
    end

    def set_chartkick_options = ::Chartkick
      .options
      .merge!(colors:, empty:)

    private

    def colors = theme_color
      .dup
      .paint
      .palette
      .analogous(as: :hex)

    def empty = ::I18n.t('schematics.application.resource.empty', locale:)
  end
end
