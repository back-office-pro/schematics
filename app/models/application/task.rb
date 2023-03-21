# frozen_string_literal: true

module Application
  module Task
    extend ActiveSupport::Concern

    prepended do
      scope :with_applicant_avatar, lambda {
        preload(applicant: { avatar_attachment: { blob: :variant_records } })
      }
    end
  end
end
