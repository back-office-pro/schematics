# frozen_string_literal: true

module Application
  module Setting
    extend ActiveSupport::Concern

    prepended do
      after_update -> { Chartkick.options[:colors] = palette }, if: :theme_color_previously_changed?
      attribute :company_name, default: Rails.application.class.module_parent_name
      attribute :theme_color, default: Rails.configuration.theme_color
    end

    def palette = theme_color
      .dup
      .paint
      .palette
      .analogous(as: :hex)
  end
end
