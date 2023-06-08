# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Charts::AccessibleByRoleQuery do
  subject(:query) { described_class }

  include_context 'with admin role'

  let(:manager_role) { Role.create!(name: 'Manager', permissions:) }
  let(:first_chart) do
    Chart.create!(
      kind: 'line',
      aggregate: 'count',
      model: 'User',
      x_field: 'User#full_name'
    )
  end
  let(:second_chart) do
    Chart.create!(
      kind: 'line',
      aggregate: 'count',
      model: 'User',
      x_field: 'User#full_name',
      roles: [admin_role]
    )
  end
  let(:third_chart) do
    Chart.create!(
      kind: 'line',
      aggregate: 'count',
      model: 'User',
      x_field: 'User#full_name',
      roles: [manager_role]
    )
  end

  before { [first_chart, second_chart, third_chart] }

  describe '.call' do
    subject { query.call(role) }

    context 'with manager role' do
      let(:role) { manager_role }

      it { is_expected.to contain_exactly(first_chart, third_chart) }
    end

    context 'with admin role' do
      let(:role) { admin_role }

      it { is_expected.to contain_exactly(first_chart, second_chart) }
    end
  end
end
