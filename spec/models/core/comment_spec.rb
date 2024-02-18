# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment do
  include Schematics::Specs::Model

  context 'when there are mentions' do
    before { allow(record).to receive(:mentions).and_return([User.new]) }

    it 'sends notifications after create' do
      expect { record.save! }
        .to have_enqueued_job(Schematics::NotifyMentionsJob)
        .with(record)
        .on_queue('notifications')
    end
  end
end
