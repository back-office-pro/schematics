# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageReply do
  include_context 'with user'

  describe '.from' do
    subject { described_class.from(parent) }

    let(:parent) { Message.new(subject: 'Test', recipients: [user], content: 'test') }

    it { is_expected.to be_a(Message) }
    its(:subject) { is_expected.to eq('RE: Test') }
    its(:recipients) { is_expected.to eq([user]) }
  end
end
