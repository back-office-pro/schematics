# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class EmailingMailerPreview < ActionMailer::Preview
    def dispatch
      EmailingMailer.dispatch(::Emailing.take, ::User.take)
    end
  end
end
