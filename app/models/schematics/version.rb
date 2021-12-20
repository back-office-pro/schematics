# frozen_string_literal: true

module Schematics
  class Version < PaperTrail::Version
    EVENTS = %w[create update destroy archive restore import].freeze

    belongs_to :user,
               class_name: 'User',
               foreign_key: :whodunnit,
               inverse_of: :versions

    delegate :entity, to: :model_class
    delegate :icon, to: :entity

    scope :with_user, -> { includes(user: [avatar_attachment: [blob: :variant_records]]) }
    scope :with_item, -> { includes(:item) }

    class << self
      def timeline(ability:, versions: nil)
        query = (versions || self)
                .with_user
                .with_item
                .accessible_by(ability)
        unless versions
          query = query
                  .joins(:user)
                  .where(
                    <<~SQL.squish
                      users.preferences -> CONCAT(versions.event, '_', versions.item_type) = 'true' OR
                      users.preferences -> CONCAT(versions.event, '_', versions.item_type) IS NULL
                    SQL
                  )
        end
        query.reorder(created_at: :desc)
      end
    end

    def model_class
      item_type.constantize
    end

    def icon
      {
        'update' => :edit,
        'create' => :plus,
        'import' => :cloud_upload_alt,
        'revert' => :undo,
        'destroy' => :trash,
        'archive' => :archive,
        'restore' => :trash_restore
      }[event] || entity.find_event_by_name(event).try(:icon)
    end
  end
end
