# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Mentionable
    extend ActiveSupport::Concern

    included do
      after_save_commit :notify_mentions
    end

    def rich_text_mentions = self
      .class
      .entity
      .rich_text_attributes
      .map(&:name)
      .map(&method(:public_send))
      .filter_map(&:body)
      .map(&:attachables)
      .flatten
      .grep(::User)
      .uniq

    protected

    def notify_mentions = ::ActiveJob.perform_all_later(
      rich_text_mentions.map { NotifyJob.new(self, 'mention', _1) }
    )
  end
end
