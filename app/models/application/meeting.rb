# frozen_string_literal: true

module Application
  module Meeting
    extend ActiveSupport::Concern

    prepended do
      scope :with_creator_avatar, lambda {
        preload(creator: { avatar_attachment: { blob: :variant_records } })
      }
    end
  end
end
