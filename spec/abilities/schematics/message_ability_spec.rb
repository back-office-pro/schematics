# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::MessageAbility do
  subject(:ability) { described_class.new(user) }

  fixtures :users, :messages, :roles, 'action_text/rich_texts'

  let(:user) { users(:one) }
  let(:other_user) { users(:two) }
  let(:message) { messages(:one) }

  it { is_expected.not_to be_able_to(:duplicate, Message) }
  it { is_expected.not_to be_able_to(:update, Message) }
  it { is_expected.not_to be_able_to(:destroy, Message) }
  it { is_expected.not_to be_able_to(:archive, Message) }
  it { is_expected.not_to be_able_to(:import, Message) }

  context 'when the user is not the author or the recipient' do
    before { message.update!(author: other_user, recipient: other_user) }

    it { is_expected.not_to be_able_to(:show, message) }
  end

  context 'when the user is the author' do
    before { message.update!(author: user, recipient: other_user) }

    it { is_expected.to be_able_to(:show, message) }
  end

  context 'when the user is the recipient' do
    before { message.update!(author: other_user, recipient: user) }

    it { is_expected.to be_able_to(:show, message) }
  end
end
