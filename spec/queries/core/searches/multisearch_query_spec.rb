# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Searches::MultisearchQuery do
  subject(:query) { described_class.new(model_class) }

  include_context 'with user'
  include_context 'with admin role'

  let(:model_class) { User }
  let(:role) { admin_role }
  let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }
  let(:ability) { Schematics::Ability.new(user) }

  before { other_user }

  describe '.call' do
    subject { query.call(param, ability) }

    context 'when looking for john' do
      let(:param) { 'john' }

      it { is_expected.to contain_exactly([user]) }
    end

    context 'when looking for jane' do
      let(:param) { 'jane' }

      it { is_expected.to contain_exactly([other_user]) }
    end
  end
end
