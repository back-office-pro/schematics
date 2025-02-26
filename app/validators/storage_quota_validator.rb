# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class StorageQuotaValidator < ActiveModel::EachValidator
  delegate :quota_storage_will_be_exceeded?, to: 'Demo::Subscription', private: true

  def validate_each(record, attribute, value)
    return unless quota_storage_will_be_exceeded? Array(value).sum(&:byte_size)

    record.errors.add(attribute, :storage_quota)
  end
end
