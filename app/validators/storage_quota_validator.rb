# frozen_string_literal: true

class StorageQuotaValidator < ActiveModel::EachValidator
  delegate :quota_storage_will_be_exceeded?, to: 'Subscription.instance', private: true

  def validate_each(record, attribute, value)
    return unless quota_storage_will_be_exceeded? Array(value).sum(&:byte_size)

    record.errors.add(attribute, :storage_quota)
  end
end
