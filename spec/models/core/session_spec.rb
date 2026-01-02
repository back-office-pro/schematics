# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session do
  include Schematics::Specs::Model

  it { is_expected.to be_sudo }

  it 'marks the session as sudo after create' do
    expect { record.save! }.to change(record, :sudo_at)
  end

  describe '.decode_access_token' do
    subject { described_class.decode_access_token(token) }

    let(:token) { record.generate_token_for(:access_token) }

    it { is_expected.to eq(record.id) }
  end

  describe '#login!' do
    subject { record.login!(user) }

    context 'when we login as current session user' do
      let(:user) { record.user }

      it { is_expected.to eq(record) }
    end

    context 'when we impersonate a user' do
      include_context 'with user'

      it { is_expected.to be_a(described_class) }
      its(:user) { is_expected.to eq(user) }
    end
  end

  describe '#touch!' do
    let(:request) { ActionController::TestRequest.create({}) }

    before { record.save! }

    it 'updates updated_at timestamp' do
      expect { record.touch!(request) }.to change(record, :updated_at)
    end
  end
end
