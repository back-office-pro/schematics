# frozen_string_literal: true

module Application
  module Task
    extend ActiveSupport::Concern

    prepended do
      scope :with_applicant, -> { preload(:applicant) }
    end

    def late?
      return false unless deadline
      return false if completed? || aborted?

      ::Time.current.after?(deadline)
    end
  end
end
