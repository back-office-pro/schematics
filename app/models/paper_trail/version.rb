module PaperTrail
  class Version < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    include PaperTrail::VersionConcern
    belongs_to :user,
               class_name: 'User',
               foreign_key: :whodunnit,
               inverse_of: :versions

    delegate :class, to: :item, prefix: true
    delegate :entity, to: :item_class
    delegate :icon, to: :entity

    scope :with_user, -> { includes(:user) }
    scope :with_item, -> { includes(:item) }

    class << self
      def timeline(ability:, versions: self)
        versions
          .with_user
          .with_item
          .order(created_at: :desc)
          .select { |version| version.item_class.accessible_by(ability) }
      end
    end
  end
end
