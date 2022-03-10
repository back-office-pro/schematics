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
    scope :filter_by_user_preferences, lambda {
      joins(:user).where(
        <<~SQL.squish
          users.preferences -> CONCAT(versions.event, '_', versions.item_type) = 'true' OR
          users.preferences -> CONCAT(versions.event, '_', versions.item_type) IS NULL
        SQL
      )
    }
    scope :read_messages, lambda {
      where(
        <<~SQL.squish
          versions.item_type = 'Message' AND
          versions.item_id = messages.id AND
          versions.event = 'show'
        SQL
      )
    }

    class << self
      def timeline(ability:, versions: nil)
        (versions || self)
          .with_user
          .with_item
          .yield_self { versions ? _1 : _1.accessible_by(ability) }
          .yield_self { versions ? _1 : _1.filter_by_user_preferences }
          .reorder(created_at: :desc)
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
        show: :eye,
        duplicate: :clone
      }[event.to_sym] || entity.find_event_by_name(event).try(:icon)
    end
  end
end
