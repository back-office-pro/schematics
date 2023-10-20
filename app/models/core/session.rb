# frozen_string_literal: true

# :reek:MissingSafeMethod
class Session < Schematics::ApplicationRecord
  ACTIVE_DELAY = 15.minutes.freeze

  scope :active, ::Core::Sessions::ActiveQuery
  scope :authorized_by, ::Core::Sessions::AuthorizedByQuery
  scope :with_user_slugs, -> { includes(user: :slugs) }
  scope :with_user_user_groups_name, -> { includes(user: { user_groups: :string_translations }) }
  scope :with_user_role_permissions, -> { includes(user: { role: :permissions }) }
  scope :with_user_role_name, -> { includes(user: { role: :string_translations }) }

  after_create_commit :sudo!

  def login!(user)
    case user
    when self.user
      self
    else
      self.class.create!(ip:, user_agent:, user:) # impersonate case
    end
  end

  def touch!(request)
    return unless request.format.html?

    update!(updated_at: Time.current)
  end

  def sudo? = Rails
    .cache
    .read("#{cache_key}/sudo")

  def sudo! = Rails
    .cache
    .write("#{cache_key}/sudo", true, expires_in: ACTIVE_DELAY)
end
