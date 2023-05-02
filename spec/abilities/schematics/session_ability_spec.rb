# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SessionAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Core::Role.new }
  let(:user) { Core::User.new(role:) }
  let(:admin_role) { Core::Role.create!(name: 'Admin') }

  it { is_expected.not_to be_able_to(:create, Core::Session) }
  it { is_expected.not_to be_able_to(:read, Core::Session) }
  it { is_expected.not_to be_able_to(:destroy, Core::Session) }
  it { is_expected.not_to be_able_to(:new, Core::Session) }
  it { is_expected.not_to be_able_to(:duplicate, Core::Session) }
  it { is_expected.not_to be_able_to(:import, Core::Session) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:create, Core::Session) }
    it { is_expected.to be_able_to(:read, Core::Session) }
    it { is_expected.to be_able_to(:destroy, Core::Session) }
    it { is_expected.not_to be_able_to(:new, Core::Session) }
    it { is_expected.not_to be_able_to(:duplicate, Core::Session) }
    it { is_expected.not_to be_able_to(:import, Core::Session) }
  end

  context 'when user is guest' do
    let(:user) { Schematics::Guest::User.new }

    it { is_expected.to be_able_to(:create, Core::Session) }
    it { is_expected.to be_able_to(:new, Core::Session) }
    it { is_expected.not_to be_able_to(:read, Core::Session) }
    it { is_expected.not_to be_able_to(:destroy, Core::Session) }
    it { is_expected.not_to be_able_to(:duplicate, Core::Session) }
    it { is_expected.not_to be_able_to(:import, Core::Session) }
  end
end
