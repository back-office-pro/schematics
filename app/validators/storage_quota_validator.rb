# frozen_string_literal: true

class StorageQuotaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    return unless Licence.instance.quota_storage_exceeded?

    record.errors.add(attribute, :storage_quota)
  end
end
