# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Metrics::AccessibleByRoleQuery do
  subject(:query) { described_class }

  include_context 'with admin role'

  let(:manager_role) { Role.create!(name: 'Manager', permissions:) }
  let(:first_metric) { Metric.create!(aggregate: 'count', model: 'User') }
  let(:second_metric) { Metric.create!(aggregate: 'count', model: 'User', roles: [admin_role]) }
  let(:third_metric) { Metric.create!(aggregate: 'count', model: 'User', roles: [manager_role]) }

  before { [first_metric, second_metric, third_metric] }

  describe '.call' do
    subject { query.call(role) }

    context 'with manager role' do
      let(:role) { manager_role }

      it { is_expected.to contain_exactly(first_metric, third_metric) }
    end

    context 'with admin role' do
      let(:role) { admin_role }

      it { is_expected.to contain_exactly(first_metric, second_metric) }
    end
  end
end
