# frozen_string_literal: true

module MainApp
  module Setting
    extend ActiveSupport::Concern

    prepended do
      after_update -> { Chartkick.options[:colors] = palette }, if: :theme_color_previously_changed?
    end

    def company_name
      super || Rails.application.class.module_parent_name
    end

    def theme_color
      super || Rails.configuration.theme_color
    end

    def theme_color_rgb
      theme_color
        .dup
        .paint
        .to_rgb
        .scan(/\d+/)
        .join(', ')
    end

    def theme_color_darken
      theme_color
        .dup
        .paint
        .darken(5)
        .to_s
    end

    def palette
      theme_color
        .dup
        .paint
        .palette
        .analogous(as: :hex)
    end
  end
end
