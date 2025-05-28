# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class EmailingMailerPreview < ActionMailer::Preview
    def dispatch
      emailing = ::Emailing.take
      user = ::User.take
      EmailingMailer.dispatch(emailing.current_shard, emailing.id, user.id)
    end
  end
end
