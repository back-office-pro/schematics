# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::UserMailer do
  include_context 'with user'

  describe '#new_account' do
    subject(:mail) { described_class.new_account(user) }

    let(:expected_subject) { I18n.t('schematics.user_mailer.new_account.subject') }
    let(:expected_body) { I18n.t('schematics.user_mailer.new_account.body.first') }

    its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
    its(:from) { is_expected.to eq(['no-reply@localhost']) }
    its(:subject) { is_expected.to eq(expected_subject) }
    its('body.encoded') { is_expected.to match(expected_body) }
  end

  describe '#password_reset' do
    subject(:mail) { described_class.password_reset(user) }

    let(:expected_subject) { I18n.t('schematics.user_mailer.password_reset.subject') }
    let(:expected_body) { I18n.t('schematics.user_mailer.password_reset.body.first') }

    its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
    its(:from) { is_expected.to eq(['no-reply@localhost']) }
    its(:subject) { is_expected.to eq(expected_subject) }
    its('body.encoded') { is_expected.to match(expected_body) }
  end
end
