# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Stats::AccessibleByRoleQuery do
  subject(:query) { described_class }

  include_context 'with admin role'

  let(:manager_role) { Role.create!(name: 'Manager', permissions:) }
  let(:first_stat) { Stat.create!(aggregate: 'count', model: 'User') }
  let(:second_stat) { Stat.create!(aggregate: 'count', model: 'User', roles: [admin_role]) }
  let(:third_stat) { Stat.create!(aggregate: 'count', model: 'User', roles: [manager_role]) }

  before { [first_stat, second_stat, third_stat] }

  describe '.call' do
    subject { query.call(role) }

    context 'with manager role' do
      let(:role) { manager_role }

      it { is_expected.to contain_exactly(first_stat, third_stat) }
    end

    context 'with admin role' do
      let(:role) { admin_role }

      it { is_expected.to contain_exactly(first_stat, second_stat) }
    end
  end
end
