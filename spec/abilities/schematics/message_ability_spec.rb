# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::MessageAbility do
  subject(:ability) { described_class.new(user) }

  let(:user) { build(:user) }
  let(:other_user) { build(:user) }
  let(:author) { nil }
  let(:recipient) { nil }
  let(:message) { build(:message, author:, recipient:) }

  it { is_expected.not_to be_able_to(:duplicate, Message) }
  it { is_expected.not_to be_able_to(:update, Message) }
  it { is_expected.not_to be_able_to(:destroy, Message) }
  it { is_expected.not_to be_able_to(:archive, Message) }
  it { is_expected.not_to be_able_to(:import, Message) }

  context 'when the user is not the author or the recipient' do
    let(:author) { other_user }
    let(:recipient) { other_user }

    it { is_expected.not_to be_able_to(:show, message) }
  end

  context 'when the user is the author' do
    let(:author) { user }
    let(:recipient) { other_user }

    it { is_expected.to be_able_to(:show, message) }
  end

  context 'when the user is the recipient' do
    let(:author) { other_user }
    let(:recipient) { user }

    it { is_expected.to be_able_to(:show, message) }
  end
end
