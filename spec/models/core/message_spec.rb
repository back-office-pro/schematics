# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  include Schematics::Specs::Model

  its(:mentions?) { is_expected.to be_falsy }

  context 'when there are mentions' do
    before { allow(record).to receive(:mentions).and_return([User.new]) }

    it 'does not send notifications after create' do
      expect { record.save! }
        .not_to have_enqueued_job(Schematics::NotifyMentionsJob)
        .with(record)
        .on_queue('notifications')
    end
  end

  describe '#read?' do
    subject { record.read?(record.author) }

    it { is_expected.to be_falsy }
  end

  describe '#new_reply' do
    subject { record.new_reply }

    it { is_expected.to be_a(described_class) }
    its(:subject) { is_expected.to start_with('RE:') }
  end
end
