# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SearchIndexes::AutocompleteQuery do
  subject(:query) { described_class }

  include_context 'with user'
  include_context 'with admin role'

  let(:ability) { Schematics::Ability.new(user) }
  let(:role) { admin_role }
  let(:search) { user.first_name }

  before { user.create_search_index }

  describe '.call' do
    subject { query.call(anything, ability, search) }

    it { is_expected.to contain_exactly(user) }
  end
end
