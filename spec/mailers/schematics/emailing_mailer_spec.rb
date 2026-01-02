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

RSpec.describe Schematics::EmailingMailer do
  include_context 'with user'

  describe '#dispatch' do
    subject { described_class.dispatch(emailing, user) }

    let(:emailing) do
      Emailing.create!(
        sender: user,
        recipients: [user],
        record: user,
        pdf_attachment: true,
        svg_attachment: true,
        email_template:
      )
    end
    let(:email_template) do
      EmailTemplate.create!(
        subject: 'Welcome!',
        content: 'Welcome {{ full_name }}'
      )
    end

    its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
    its(:from) { is_expected.to eq(['no-reply@localhost']) }
    its(:subject) { is_expected.to eq('Welcome!') }
    its('body.encoded') { is_expected.to match('Welcome DOE John') }
    its('attachments.size') { is_expected.to eq(2) }
  end
end
