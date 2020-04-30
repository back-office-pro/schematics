module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern
    belongs_to :user, class_name: 'User', foreign_key: :whodunnit

    delegate :entity, to: :model_class
    delegate :icon, to: :entity

    scope :with_user, -> { includes(:user) }
    scope :with_item, -> { includes(:item) }

    def model_class
      item_type.constantize
    end
  end
end
