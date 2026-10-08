# frozen_string_literal: true

class StorageQuotaValidator < ActiveModel::EachValidator
  delegate :storage_quota_will_be_exceeded?, to: '::Configuration.license', private: true

  def validate_each(record, attribute, value)
    return unless storage_quota_will_be_exceeded? Array(value).sum(&:byte_size)

    record.errors.add(attribute, :storage_quota)
  end
end
