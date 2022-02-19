# frozen_string_literal: true

module MainApp
  module User
    extend ActiveSupport::Concern

    prepended do
      after_create :regenerate_password_reset_token
      after_create { Schematics::UserMailer.new_account(self).deliver_later }
    end
  end
end
