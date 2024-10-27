# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Rankings::AccessibleByRoleQuery do
  subject(:query) { described_class }

  include_context 'with admin role'

  let(:manager_role) { Role.create!(name: 'Manager', permissions:) }
  let(:first_ranking) do
    Ranking.create!(
      model: 'Migration',
      field: 'Migration#version'
    )
  end
  let(:second_ranking) do
    Ranking.create!(
      model: 'Migration',
      field: 'Migration#progress',
      roles: [admin_role]
    )
  end
  let(:third_ranking) do
    Ranking.create!(
      model: 'Import',
      field: 'Import#progress',
      roles: [manager_role]
    )
  end

  before { [first_ranking, second_ranking, third_ranking] }

  describe '.call' do
    subject { query.call(role) }

    context 'with manager role' do
      let(:role) { manager_role }

      it { is_expected.to contain_exactly(first_ranking, third_ranking) }
    end

    context 'with admin role' do
      let(:role) { admin_role }

      it { is_expected.to contain_exactly(first_ranking, second_ranking) }
    end
  end
end
