# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SessionAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with admin role'

  let(:role) { Role.new }
  let(:user) { User.new(role:) }

  it { is_expected.not_to be_able_to(:create, Session) }
  it { is_expected.not_to be_able_to(:read, Session) }
  it { is_expected.not_to be_able_to(:destroy, Session) }
  it { is_expected.not_to be_able_to(:new, Session) }
  it { is_expected.not_to be_able_to(:duplicate, Session) }
  it { is_expected.not_to be_able_to(:import, Session) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:create, Session) }
    it { is_expected.to be_able_to(:read, Session) }
    it { is_expected.to be_able_to(:destroy, Session) }
    it { is_expected.not_to be_able_to(:new, Session) }
    it { is_expected.not_to be_able_to(:duplicate, Session) }
    it { is_expected.not_to be_able_to(:import, Session) }
  end

  context 'when user is guest' do
    let(:user) { Schematics::Guest::User.new }

    it { is_expected.to be_able_to(:create, Session) }
    it { is_expected.to be_able_to(:new, Session) }
    it { is_expected.not_to be_able_to(:read, Session) }
    it { is_expected.not_to be_able_to(:destroy, Session) }
    it { is_expected.not_to be_able_to(:duplicate, Session) }
    it { is_expected.not_to be_able_to(:import, Session) }
  end
end
