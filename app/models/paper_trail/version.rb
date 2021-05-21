# frozen_string_literal: true

module PaperTrail
  class Version < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    include PaperTrail::VersionConcern

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
      def timeline(ability:, preferences: {}, versions: self)
        versions
          .with_user
          .with_item
          .order(created_at: :desc)
          .select { |version| version.visible?(ability, preferences) }
      end
    end

    def model_class
      item_type.constantize
    end

    def visible?(ability, preferences)
      ability.can?(event.to_sym, model_class) && preferences.fetch(preference, true)
    end

    def icon
      {
        'update' => :edit,
        'create' => :plus,
        'import' => :cloud_upload_alt,
        'destroy' => :trash,
        'archive' => :archive,
        'restore' => :trash_restore,
      }[event]
    end

    private

    def preference
      [event, item_type.underscore].join('_')
    end
  end
end
