# frozen_string_literal: true

module Application
  module Task
    extend ActiveSupport::Concern

    def late?
      return false unless deadline
      return false unless pending?

      ::Time.current.after?(deadline)
    end
  end
end
