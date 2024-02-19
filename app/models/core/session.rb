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

  class << self
    def decode_auth_token(token, *)
      signed_id_verifier.verified(token, purpose: name.underscore)
    end
  end

  def login!(user)
    case user
    when self.user
      self
    else
      self.class.create!(ip:, user_agent:, user:) # impersonate case
    end
  end

  def touch!(request, *)
    unstale.update!(updated_at: Time.current) if request.format.html?
  end

  def sudo?
    sudo_at&.after?(ACTIVE_DELAY.ago)
  end

  def sudo!
    update!(sudo_at: Time.current)
  end
end
