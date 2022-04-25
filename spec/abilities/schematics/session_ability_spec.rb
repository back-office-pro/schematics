# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SessionAbility do
  subject(:ability) { described_class.new(user) }

  fixtures :sessions, :users

  let(:session) { sessions(:one) }
  let(:user) { session.user }

  it { is_expected.to be_able_to(:destroy, session) }

  context 'when user is admin' do
    before { allow(user).to receive(:admin?).and_return(true) }

    it { is_expected.to be_able_to(:read, ::Session) }
    it { is_expected.to be_able_to(:destroy, ::Session) }
  end
end
