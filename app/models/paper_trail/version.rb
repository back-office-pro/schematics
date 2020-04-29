module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern
    belongs_to :user, class_name: 'User', foreign_key: :whodunnit
    scope :with_user, -> { includes(:user) }
    scope :with_item, -> { includes(:item) }
  end
end
