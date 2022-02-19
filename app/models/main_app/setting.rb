# frozen_string_literal: true

module MainApp
  module Setting
    extend ActiveSupport::Concern

    prepended do
      after_update -> { system('rake assets:clobber') }, if: :theme_color_previously_changed?
      after_update -> { Chartkick.options[:colors] = palette }, if: :theme_color_previously_changed?
    end

    def company_name
      super || Rails.application.class.module_parent_name
    end

    def theme_color
      super || Rails.configuration.theme_color
    end

    def palette
      theme_color
        .dup
        .paint
        .palette
        .analogous(as: :hex)
    rescue Chroma::Errors::UnrecognizedColor
      Rails
        .configuration
        .theme_color
        .dup
        .paint
        .palette
        .analogous(as: :hex)
    end
  end
end
