# Copyright © 2025 Dev & Software. All rights reserved.
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
    its(:from) { is_expected.to eq(['no-reply@back-office.pro']) }
    its(:subject) { is_expected.to eq('Welcome!') }
    its('body.encoded') { is_expected.to match('Welcome DOE John') }
    its('attachments.size') { is_expected.to eq(2) }
  end
end
