# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::ResourceMailer do
  include_context 'with user'

  describe '#forward' do
    subject(:mail) { described_class.forward(user, user, resources) }

    let(:expected_subject) { I18n.t('schematics.resource_mailer.forward.subject') }
    let(:expected_body) { I18n.t('schematics.resource_mailer.forward.body.second', sender: user) }

    context 'when there is only one resource' do
      let(:resources) { user }

      its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
      its(:from) { is_expected.to eq(['no-reply@localhost']) }
      its(:subject) { is_expected.to eq(expected_subject) }
      its('body.encoded') { is_expected.to match(expected_body) }
      its('attachments.size') { is_expected.to eq(2) }
    end

    context 'when there are multiple resources' do
      let(:resources) { [user] }

      its(:to) { is_expected.to eq(['john.doe@nowhere.com']) }
      its(:from) { is_expected.to eq(['no-reply@localhost']) }
      its(:subject) { is_expected.to eq(expected_subject) }
      its('body.encoded') { is_expected.to match(expected_body) }
      its('attachments.size') { is_expected.to eq(1) }
    end
  end
end
