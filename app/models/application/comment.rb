# frozen_string_literal: true

module Application
  module Comment
    extend ActiveSupport::Concern

    prepended do
      scope :with_author_avatar, lambda {
        preload(author: { avatar_attachment: { blob: :variant_records } })
      }
    end
  end
end
