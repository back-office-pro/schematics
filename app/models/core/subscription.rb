# frozen_string_literal: true

# :reek:MissingSafeMethod
class Subscription < Schematics::ApplicationRecord
  GATEWAY = ::Core::Subscriptions::Stripe

  delegate :entities, :users, :api_keys, :databases, to: :quota, prefix: true

  def load!
    PaperTrail.request(enabled: false) do
      update!(GATEWAY::Fetch.call.data)
      ::Core::Migrations::Restart.call if metadata_previously_changed?
    end
  end

  def after_enable_event = GATEWAY::Enable.call

  def after_cancel_event = GATEWAY::Cancel.call

  def entities_size = Tenant
    .schema
    .entities
    .reject(&:core?) # rubocop:disable Performance/Count
    .size

  def quota = Data
    .define(:entities, :storage, :users, :api_keys, :databases, :support)
    .new(**metadata)

  def quota_entities_percentage
    entities_size * 100 / quota_entities
  end

  def quota_storage_will_be_exceeded?(size)
    storage_size + size.bytes >= quota_storage
  end

  def quota_storage_percentage
    storage_size * 100 / quota_storage
  end

  def quota_users_exceeded?
    users_size >= quota_users
  end

  def quota_users_percentage
    users_size * 100 / quota_users
  end

  def quota_api_keys_exceeded?
    api_keys_size >= quota_api_keys
  end

  def quota_api_keys_percentage
    api_keys_size * 100 / quota_api_keys
  end

  def live_support? = quota
    .support
    .positive?

  def email_support? = quota
    .support
    .zero?

  def quota_storage = quota
    .storage
    .gigabytes

  def storage_size = ActiveStorage::Blob
    .with_deleted
    .sum(&:byte_size)
    .bytes

  memoize def users_size = User.count

  memoize def api_keys_size = APIKey.count
end
