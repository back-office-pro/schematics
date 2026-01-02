# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::MessageAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with user'

  let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }
  let(:message) { Message.create!(subject: 'Foo', content: 'Lorem', author:, recipients:) }
  let(:author) { nil }
  let(:recipients) { [] }

  it { is_expected.not_to be_able_to(:comment, Message) }
  it { is_expected.not_to be_able_to(:duplicate, Message) }
  it { is_expected.not_to be_able_to(:import, Message) }

  context 'when the user is not the author or among recipients' do
    let(:author) { other_user }
    let(:recipients) { [other_user] }

    it { is_expected.not_to be_able_to(:read, message) }
    it { is_expected.not_to be_able_to(:reply, message) }
    it { is_expected.not_to be_able_to(:update, message) }
    it { is_expected.not_to be_able_to(:destroy, message) }
    it { is_expected.not_to be_able_to(:archive, message) }
  end

  context 'when the user is the author' do
    let(:author) { user }
    let(:recipients) { [other_user] }

    it { is_expected.to be_able_to(:read, message) }
    it { is_expected.to be_able_to(:reply, message) }
    it { is_expected.to be_able_to(:update, message) }
    it { is_expected.to be_able_to(:destroy, message) }
    it { is_expected.to be_able_to(:archive, message) }
  end

  context 'when the user is among recipients' do
    let(:author) { other_user }
    let(:recipients) { [user] }

    it { is_expected.to be_able_to(:read, message) }
    it { is_expected.to be_able_to(:reply, message) }
    it { is_expected.not_to be_able_to(:update, message) }
    it { is_expected.not_to be_able_to(:destroy, message) }
    it { is_expected.not_to be_able_to(:archive, message) }
  end

  context 'when the user is the author but there is a reply' do
    let(:author) { user }
    let(:recipients) { [other_user] }
    let(:reply) do
      Message.create!(
        subject: 'RE: Foo',
        content: 'Lorem',
        author:,
        recipients:,
        parent: message
      )
    end

    before { reply }

    it { is_expected.to be_able_to(:read, message) }
    it { is_expected.not_to be_able_to(:reply, message) }
    it { is_expected.not_to be_able_to(:update, message) }
    it { is_expected.not_to be_able_to(:destroy, message) }
    it { is_expected.to be_able_to(:archive, message) }
  end
end
