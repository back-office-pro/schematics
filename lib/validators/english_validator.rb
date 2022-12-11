# frozen_string_literal: true

require 'active_model'

class EnglishValidator < ActiveModel::EachValidator
  # :reek:UtilityFunction
  def validate_each(record, attribute, value)
    detection = EasyTranslate.detect(value.humanize, confidence: true)
    return if detection[:confidence] < 1
    return if detection[:language] == 'en'

    record.errors.add(attribute, :english)
  rescue NameError, EasyTranslate::EasyTranslateException
    nil
  end
end
