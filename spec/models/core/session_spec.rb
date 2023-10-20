# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session do
  include Schematics::Specs::Model

  it { is_expected.not_to be_sudo }

  describe '#login!' do
    subject { record.login!(user) }

    context 'when we login as current session user' do
      let(:user) { record.user }

      it { is_expected.to eq(record) }
    end

    context 'when we impersonate a user' do
      include_context 'with user'

      it { is_expected.to be_a(described_class) }
      it { is_expected.to have_attributes(user:) }
    end
  end

  describe '#touch!' do
    let(:request) { ActionController::TestRequest.create({}) }

    it 'updates updated_at timestamp' do
      expect { record.touch!(request) }.to change(record, :updated_at)
    end
  end
end
