# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class ::Message < Schematics::ApplicationRecord
  scope :unread, ::Core::Messages::UnreadQuery
  scope :read, ::Core::Messages::ReadQuery

  def new_reply = self
    .class
    .new(
      subject: subject.dup.prepend('RE: '),
      recipients:,
      content: <<~HTML
        <blockquote>#{content}</blockquote>
        <br />
      HTML
    )

  def read?(user)
    paper_trail_versions.exists?(event: 'show', user:)
  end

  def rich_text_mentions = []
end
