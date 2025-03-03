# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class Version < ::Server.application_record_class
    self.table_name = :paper_trail_versions # rubocop:disable Rails/TableNameAssignment

    include ::PaperTrail::VersionConcern
    include Serializable
    include Identifiable
    include Translatable

    EVENTS = %w[create update destroy archive restore import duplicate].freeze

    belongs_to :user,
               class_name: 'Demo::User',
               foreign_key: :whodunnit,
               inverse_of: :paper_trail_versions

    delegate :entity, :human_name, :gender, to: :model_class, allow_nil: true

    scope :unread, Versions::UnreadQuery
    scope :read_messages, Versions::ReadMessagesQuery
    scope :filter_by_user_preferences, Versions::FilterByUserPreferencesQuery
    scope :timeline, Versions::TimelineQuery
    scope :with_user, lambda {
      includes(
        user: [
          :string_translations,
          { teams: :string_translations },
          { avatar_attachment: { blob: :variant_records } }
        ]
      )
    }

    after_create_commit :broadcast_webhook_event

    def icon
      {
        update: :pen_to_square,
        create: :plus,
        import: :cloud_arrow_down,
        revert: :arrow_rotate_left,
        destroy: :trash,
        archive: :box_archive,
        restore: :trash_arrow_up,
        show: :eye,
        duplicate: :clone,
        mention: :quote_left
      }[event.to_sym] || entity.find_event_by_name(event).try(:icon)
    end

    def model_class
      item_type.safe_constantize
    end

    def serialized_json(*)
      {
        id:,
        created_at:,
        event:,
        item: item.as_json(association: false),
        user: user.as_json(association: true),
        object_changes:
      }
    end

    private

    memoize def webhook_event
      Demo::Permission.find_by(model: item_type, action: event)
    end

    def broadcast_webhook_event
      return unless webhook_event

      PaperTrail.request(enabled: false) do
        Demo::WebhookEndpoint.broadcast_all(webhook_event, item&.as_json(association: false))
      end
    end
  end
end
