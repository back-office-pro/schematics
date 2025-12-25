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

RSpec.describe Schematics::UserMailer do
  include_context 'with user'

  describe '#new_account' do
    subject(:mail) { described_class.new_account(user) }

    let(:expected_subject) { 'Activate your account' }
    let(:expected_body) do
      <<~TEXT.squish
        Hello DOE John,To set up your password click the link below.http://localhost/passwords
      TEXT
    end

    its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
    its(:from) { is_expected.to eq(['no-reply@localhost']) }
    its(:subject) { is_expected.to eq(expected_subject) }
    its('text_part.body.encoded') { is_expected.to start_with(expected_body) }
  end

  describe '#password_reset' do
    subject(:mail) { described_class.password_reset(user) }

    let(:expected_subject) { 'Password reset' }
    let(:expected_body) do
      <<~TEXT.squish
        Hello DOE John,To reset your password click the link below.http://localhost/passwords
      TEXT
    end

    its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
    its(:from) { is_expected.to eq(['no-reply@localhost']) }
    its(:subject) { is_expected.to eq(expected_subject) }
    its('text_part.body.encoded') { is_expected.to start_with(expected_body) }
  end
end
