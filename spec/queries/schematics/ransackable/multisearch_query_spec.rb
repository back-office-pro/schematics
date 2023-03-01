# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Ransackable::MultisearchQuery do
  subject(:query) { described_class.new(model_class) }

  include_context 'with user'

  let(:model_class) { User }
  let(:permissions) { Permission.create_all_entities_permissions! }
  let(:role) { Role.create!(name: 'Admin', permissions:) }
  let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }
  let(:ability) { Schematics::Ability.new(user) }

  describe '.call' do
    subject { query.call(param, ability) }

    context 'when looking for john' do
      let(:param) { 'john' }

      it { is_expected.to contain_exactly(user) }
    end

    context 'when looking for jane' do
      let(:param) { 'jane' }

      it { is_expected.to contain_exactly(other_user) }
    end
  end
end
