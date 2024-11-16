# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Dashboards::AccessibleByRoleQuery do
  subject(:query) { described_class }

  include_context 'with admin role'

  let(:manager_role) { Role.create!(name: 'Manager', permissions:) }
  let(:first_dashboard) { Dashboard.create!(title: 'Dashboard 1') }
  let(:second_dashboard) { Dashboard.create!(title: 'Dashboard 2', roles: [admin_role]) }
  let(:third_dashboard) { Dashboard.create!(title: 'Dashboard 3', roles: [manager_role]) }

  before { [first_dashboard, second_dashboard, third_dashboard] }

  describe '.call' do
    subject { query.call(role) }

    context 'with manager role' do
      let(:role) { manager_role }

      it { is_expected.to contain_exactly(first_dashboard, third_dashboard) }
    end

    context 'with admin role' do
      let(:role) { admin_role }

      it { is_expected.to contain_exactly(first_dashboard, second_dashboard) }
    end
  end
end
