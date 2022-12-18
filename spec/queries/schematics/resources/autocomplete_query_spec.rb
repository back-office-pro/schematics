# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Resources::AutocompleteQuery do
  subject(:query) { described_class.new(model_class) }

  include_context 'with user'

  let(:model_class) { User }
  let(:permissions) { Permission.create_all_entities_permissions! }
  let(:role) { Role.create!(name: 'Admin', permissions:) }
  let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }
  let(:ability) { Schematics::Ability.new(user) }
  let(:field) { 'email' }

  before { other_user }

  describe '.call' do
    subject { query.call(params, field, ability) }

    context 'when looking for john' do
      let(:params) { { email_i_cont: 'john' } }

      it { is_expected.to contain_exactly('john.doe@nowhere.com') }
    end

    context 'when looking for jane' do
      let(:params) { { email_i_cont: 'jane' } }

      it { is_expected.to contain_exactly('jane.doe@nowhere.com') }
    end
  end
end
