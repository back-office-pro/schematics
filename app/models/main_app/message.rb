# frozen_string_literal: true

module MainApp
  module Message
    extend ActiveSupport::Concern

    prepended do
      scope :unread, UnreadQuery
      scope :with_author_avatar, lambda {
        includes(author: { avatar_attachment: { blob: :variant_records } })
      }
    end
  end
end
