# frozen_string_literal: true

# :reek:MissingSafeMethod
class Licence < Schematics::ApplicationRecord
  GATEWAY = ::Core::Licences::Stripe

  def load!
    PaperTrail.request(enabled: false) do
      update!(GATEWAY::Fetch.call.data)
      reload && update_env_file if metadata_previously_changed?
    end
  end

  def after_enable = GATEWAY::Enable.call

  def after_cancel = GATEWAY::Cancel.call

  def entities_size = Tenant
    .schema
    .entities
    .reject(&:core?) # rubocop:disable Performance/Count
    .size

  def quota = Data
    .define(:entities, :storage, :users, :api_keys, :databases, :support)
    .new(**metadata)

  def quota_entities_exceeded?
    return true unless active?

    entities_size >= quota.entities
  end

  def quota_entities_percentage
    entities_size * 100 / quota.entities
  end

  def quota_storage_exceeded?
    return true unless active?

    storage_size >= quota.storage
  end

  def quota_storage_percentage
    storage_size * 100 / quota.storage.gigabytes
  end

  def quota_users_exceeded?
    return true unless active?

    users_size >= quota.users
  end

  def quota_users_percentage
    users_size * 100 / quota.users
  end

  def quota_api_keys_exceeded?
    return true unless active?

    api_keys_size >= quota.api_keys
  end

  def quota_api_keys_percentage
    api_keys_size * 100 / quota.api_keys
  end

  def live_support? = quota
    .support
    .positive?

  def email_support? = quota
    .support
    .zero?

  def storage_size
    ActiveStorage::Blob.sum(&:byte_size)
  end

  memoize def users_size = User.count

  memoize def api_keys_size = ApiKey.count

  private

  def search_engine
    return 'elasticsearch' if quota.databases > 2

    'postgresql'
  end

  def backend
    return 'redis' if quota.databases > 1

    'postgresql'
  end

  def update_env_file
    filepath = Rails.root.join('.env')
    filepath.write filepath
      .read
      .gsub(/BACKEND=(.*)/, "BACKEND=#{backend}")
      .gsub(/SEARCH_ENGINE=(.*)/, "SEARCH_ENGINE=#{search_engine}")
    FileUtils.touch Rails.root.join('tmp/restart.txt')
  end
end
