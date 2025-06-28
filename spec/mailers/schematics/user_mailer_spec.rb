# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::UserMailer do
  include_context 'with user'

  let(:shard) { :default }

  describe '#new_account' do
    subject(:mail) { described_class.with(shard:).new_account(user.id) }

    let(:expected_subject) { 'Activate your account' }
    let(:expected_body) do
      <<~TEXT.squish
        Hello DOE John,To set up your password click the link below.http://default.back-office.pro/passwords
      TEXT
    end

    its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
    its(:from) { is_expected.to eq(['no-reply@back-office.pro']) }
    its(:subject) { is_expected.to eq(expected_subject) }
    its('text_part.body.encoded') { is_expected.to start_with(expected_body) }
  end

  describe '#password_reset' do
    subject(:mail) { described_class.with(shard:).password_reset(user.id) }

    let(:expected_subject) { 'Password reset' }
    let(:expected_body) do
      <<~TEXT.squish
        Hello DOE John,To reset your password click the link below.http://default.back-office.pro/passwords
      TEXT
    end

    its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
    its(:from) { is_expected.to eq(['no-reply@back-office.pro']) }
    its(:subject) { is_expected.to eq(expected_subject) }
    its('text_part.body.encoded') { is_expected.to start_with(expected_body) }
  end
end
