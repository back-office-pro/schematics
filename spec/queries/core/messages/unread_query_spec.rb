# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Messages::UnreadQuery do
  include_context 'with user'

  let(:version) { Schematics::Version.create!(event: 'show', item: message, user:) }
  let(:message) do
    Message.create!(subject: 'Foo', content: 'Lorem', author: user, recipients: [user])
  end

  before { message }

  context 'when message is not read' do
    its(:call) { is_expected.to contain_exactly(message) }
  end

  context 'when message is read' do
    before { version }

    its(:call) { is_expected.to be_empty }
  end
end
