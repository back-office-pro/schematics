# frozen_string_literal: true

module Schematics
  class Version < PaperTrail::Version
    include Translatable

    EVENTS = %w[create update destroy archive restore import duplicate].freeze

    belongs_to :user, class_name: 'User', foreign_key: :whodunnit, inverse_of: :versions

    delegate :entity, :human_name, :gender, to: :model_class, allow_nil: true

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
    scope :timeline, lambda { |ability, versions = nil|
      (versions || self)
        .with_user
        .with_item
        .then_tap { _1.accessible_by(ability) unless versions }
        .then_tap { _1.filter_by_user_preferences unless versions }
        .reorder(created_at: :desc)
        .load_async
    }

    def model_class
      item_type.safe_constantize
    end

    def icon
      {
        update: :pen_to_square,
        create: :plus,
        import: :cloud_arrow_up,
        revert: :arrow_rotate_left,
        destroy: :trash,
        archive: :box_archive,
        restore: :trash_arrow_up,
        show: :eye,
        duplicate: :clone
      }[event.to_sym] || entity.find_event_by_name(event).try(:icon)
    end
  end
end
