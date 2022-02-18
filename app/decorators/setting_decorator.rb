# frozen_string_literal: true

class SettingDecorator < Draper::Decorator
  delegate_all

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
