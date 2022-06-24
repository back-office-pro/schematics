# frozen_string_literal: true

module Application
  module Message
    extend ActiveSupport::Concern

    prepended do
      scope :unread, UnreadQuery
      scope :with_author_avatar, lambda {
        preload(author: { avatar_attachment: { blob: :variant_records } })
      }
    end

    def mentions = content
      .body
      .attachables
      .select_is_a?(::User)
      .uniq
  end
end
