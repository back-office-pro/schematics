# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Searchkickable::AutocompleteQuery do
  subject(:query) { described_class.new(model_class) }

  include_context 'with user'

  let(:model_class) { User }
  let(:permissions) { Permission.create_entities_permissions! }
  let(:role) { Role.create!(name: 'Admin', permissions:) }
  let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }
  let(:ability) { Schematics::Ability.new(user) }
  let(:field) { 'email' }

  before { [user, other_user, User.include(Schematics::Searchkickable).tap(&:reindex)] }

  after { User.reload_definitions! }

  describe '.call' do
    subject { query.call(params, ability, field) }

    context 'when looking for john' do
      let(:params) { { email: 'john' } }

      it { is_expected.to contain_exactly('john.doe@nowhere.com') }
    end

    context 'when looking for jane' do
      let(:params) { { email: 'jane' } }

      it { is_expected.to contain_exactly('jane.doe@nowhere.com') }
    end
  end
end
