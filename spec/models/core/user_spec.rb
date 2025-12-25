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

RSpec.describe User do
  include Schematics::Specs::Model

  it { is_expected.not_to be_admin }
  it { is_expected.not_to be_online }

  it 'sends a mail after create' do
    expect { record.save! }
      .to have_enqueued_mail(Schematics::UserMailer, :new_account)
      .with(record)
      .on_queue('default')
  end

  describe '#log_search!' do
    subject(:log_search!) { record.log_search!(model, filters) }

    let(:model) { 'User' }

    before { record.save! }

    context 'when there are filters' do
      let(:filters) { { email: 'john.doe@nowhere.com' } }

      it 'creates a new search' do
        expect { log_search! }.to change(record.searches, :count).by(1)
      end
    end

    context 'when filters are empty' do
      let(:filters) { {} }

      it 'does not create a new search' do
        expect { log_search! }.not_to change(record.searches, :count)
      end
    end
  end

  describe '#find_or_create_draft!' do
    subject(:find_or_create_draft!) { record.find_or_create_draft!(record_type, record_id) }

    let(:record_type) { record.class }
    let(:record_id) { record.id }

    before { record.save! }

    it 'creates a new draft' do
      expect { find_or_create_draft! }
        .to change(record.user_drafts, :count)
        .by(1)
    end
  end
end
