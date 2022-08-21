# frozen_string_literal: true

module Schematics
  class Version < PaperTrail::Version
    include Translatable

    EVENTS = %w[create update destroy archive restore import duplicate].freeze

    belongs_to :user, class_name: 'User', foreign_key: :whodunnit, inverse_of: :versions
    belongs_to :item, polymorphic: true, optional: true, strict_loading: false, inverse_of: false

    delegate :entity, :human_name, :gender, to: :model_class, allow_nil: true

    scope :unread, UnreadVersionQuery
    scope :read_messages, ReadMessagesVersionQuery
    scope :filter_by_user_preferences, FilterByUserPreferencesVersionQuery
    scope :timeline, TimelineVersionQuery
    scope :with_user, -> { preload(user: [avatar_attachment: [blob: :variant_records]]) }
    scope :with_item, -> { preload(:item) }

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

    def model_class
      item_type.safe_constantize
    end
  end
end
