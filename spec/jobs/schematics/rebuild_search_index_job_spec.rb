# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::RebuildSearchIndexJob do
  include_context 'with user'

  describe '#perform_later' do
    before { user.create_search_index }

    it 'queues the job' do
      expect { described_class.perform_later(user) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(user)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(resource) }

    context 'when updating a user' do
      let(:resource) { user }

      before { user.create_search_index }

      it 'rebuilds the search index' do
        expect { perform_now }.not_to change(Schematics::SearchIndex, :count)
      end
    end

    context 'when updating all users' do
      let(:resource) { User }
      let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }

      before { [user, other_user].each(&:create_search_index) }

      it 'rebuilds the search indexes' do
        expect { perform_now }.not_to change(Schematics::SearchIndex, :count)
      end
    end
  end
end
