# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Searchkickable::ListQuery do
  subject(:query) { described_class.new(model_class) }

  include_context 'with user'
  include_context 'with admin role'

  let(:model_class) { User }
  let(:role) { admin_role }
  let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }
  let(:ability) { Schematics::Ability.new(user) }

  before { [user, other_user, User.include(Schematics::Searchkickable).tap(&:reindex)] }

  after { User.reload_definitions! }

  describe '.call' do
    subject { pagy_search.first.search(pagy_search.second, **pagy_search.third) }

    let(:pagy_search) { query.call(filter_params, ability) }

    context 'when looking for john' do
      let(:filter_params) { { email: 'john' } }

      it { is_expected.to contain_exactly(user) }
    end

    context 'when looking for jane' do
      let(:filter_params) { { email: 'jane' } }

      it { is_expected.to contain_exactly(other_user) }
    end
  end
end
