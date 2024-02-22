# frozen_string_literal: true

module Schematics
  class EmailingMailerPreview < ActionMailer::Preview
    def dispatch
      EmailingMailer.dispatch(::Emailing.first, ::User.first)
    end
  end
end
