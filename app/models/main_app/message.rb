# frozen_string_literal: true

module MainApp
  module Message
    extend ActiveSupport::Concern

    prepended do
      scope :with_author_avatar, lambda {
        includes(author: { avatar_attachment: { blob: :variant_records } })
      }
      scope :unread, lambda {
        where(
          'NOT EXISTS (:version)',
          version: Schematics::Version.where(
            <<~SQL.squish
              versions.item_type = 'Message' AND
              versions.item_id = messages.id AND
              versions.event = 'show'
            SQL
          )
        ).load_async
      }
    end
  end
end
