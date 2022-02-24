# frozen_string_literal: true

module Schematics
  class Version < PaperTrail::Version
    include Translatable

    EVENTS = %w[create update destroy archive restore import].freeze

    belongs_to :user, class_name: 'User', foreign_key: :whodunnit, inverse_of: :versions

    delegate :entity, :human_name, :gender, to: :model_class
    delegate :icon, to: :entity

    scope :with_user, -> { includes(user: [avatar_attachment: [blob: :variant_records]]) }
    scope :with_item, -> { includes(:item) }

    class << self
      def timeline(ability:, versions: nil)
        (versions || self)
          .with_user
          .with_item
          .yield_self { versions ? _1 : _1.accessible_by(ability) }
          .yield_self { versions ? _1 : _1.joins(:user).where(user_preferences_conditions) }
          .reorder(created_at: :desc)
      end

      private

      def user_preferences_conditions
        <<~SQL.squish
          users.preferences -> CONCAT(versions.event, '_', versions.item_type) = 'true' OR
          users.preferences -> CONCAT(versions.event, '_', versions.item_type) IS NULL
        SQL
      end
    end

    def model_class
      item_type.constantize
    end

    def icon
      {
        update: :edit,
        create: :plus,
        import: :cloud_upload_alt,
        revert: :undo,
        destroy: :trash,
        archive: :archive,
        restore: :trash_restore,
        show: :eye
      }[event.to_sym] || entity.find_event_by_name(event).try(:icon)
    end
  end
end
