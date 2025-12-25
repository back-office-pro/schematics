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
