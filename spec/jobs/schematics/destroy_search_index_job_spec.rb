# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::DestroySearchIndexJob do
  include_context 'with user'

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(searchable_id: user.id) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(**params) }

    context 'when destroying a user' do
      let(:params) { { searchable_id: user.id } }

      before { user.create_search_index }

      it 'destroys the search index' do
        expect { perform_now }
          .to change(Schematics::SearchIndex, :count)
          .by(-1)
      end
    end

    context 'when destroying all users' do
      let(:params) { { searchable_type: 'User' } }
      let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }

      before { [user, other_user].each(&:create_search_index) }

      it 'destroys the search indexes' do
        expect { perform_now }
          .to change(Schematics::SearchIndex, :count)
          .by(-2)
      end
    end
  end
end
