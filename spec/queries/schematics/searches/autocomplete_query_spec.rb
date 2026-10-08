# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Searches::AutocompleteQuery do
  subject(:query) { described_class.new(model_class) }

  include_context 'with user'
  include_context 'with admin role'

  let(:model_class) { User }
  let(:role) { admin_role }
  let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }
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
