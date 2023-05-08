# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Ransackable::AutocompleteQuery do
  subject(:query) { described_class.new(model_class) }

  include_context 'with user'

  let(:model_class) { Core::User }
  let(:permissions) { Core::Permission.create_entities_permissions! }
  let(:role) { Core::Role.create!(name: 'Admin', permissions:) }
  let(:other_user) { Core::User.create!(email: 'jane.doe@nowhere.com', role:) }
  let(:ability) { Schematics::Ability.new(user) }
  let(:field) { 'email' }

  before { other_user }

  describe '.call' do
    subject { query.call(params, ability, field) }

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
