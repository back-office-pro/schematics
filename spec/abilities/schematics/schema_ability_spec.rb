# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SchemaAbility do
  subject(:ability) { described_class.new(user) }

  fixtures :users

  let(:user) { users(:one) }

  it { is_expected.not_to be_able_to(:update, Schematics::Schema) }

  context 'when user is admin' do
    before { allow(user).to receive(:admin?).and_return(true) }

    it { is_expected.to be_able_to(:update, Schematics::Schema) }
  end
end
