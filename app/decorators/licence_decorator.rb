# frozen_string_literal: true

class LicenceDecorator < Draper::Decorator
  delegate_all
  decorates_finders

  LICENCES = YAML.load_file(Schematics::Engine.root.join('lib', 'licences.yml'))

  def users_size
    User.count
  end

  def storage_size
    ActiveStorage::Attachment.sum(&:byte_size)
  end

  def entities_size
    Schematics::Schema
      .instance
      .entities
      .size - 8
  end

  def quota
    OpenStruct.new(LICENCES[plan])
  end

  def quota_users_percentage
    users_size * 100 / quota.users
  end

  def quota_storage_percentage
    storage_size * 100 / quota.storage.gigabytes
  end

  def quota_entities_percentage
    entities_size * 100 / quota.entities
  end

  def quota_users_exceeded?
    users_size >= quota.users
  end

  def quota_storage_exceeded?
    storage_size >= quota.storage
  end

  def quota_entities_exceeded?
    entities_size >= quota.entities
  end

  def expired?
    Time.current >= expires_at
  end
end
