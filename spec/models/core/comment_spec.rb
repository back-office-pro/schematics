# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment do
  include Schematics::Specs::Model

  include_context 'with user'

  context 'when there are mentions' do
    before { allow(record).to receive(:mentions).and_return([user]) }

    it 'sends notifications after save' do
      expect { record.save! }
        .to have_enqueued_job(Schematics::NotifyJob)
        .with(record, 'mention', user)
        .on_queue('notifications')
    end
  end
end
