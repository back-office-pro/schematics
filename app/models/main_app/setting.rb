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

    def palette = theme_color
      .dup
      .paint
      .palette
      .analogous(as: :hex)

    def theme_color
      super || Rails.configuration.theme_color
    end
  end
end
