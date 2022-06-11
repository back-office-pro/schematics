# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Search::TypeaheadHistoryQuery do
  subject(:query) { described_class }

  include_context 'with user'

  let(:model) { 'User' }
  let(:name) { 'email' }
  let(:first_search) { Search.create!(model:, filters: { email: 'foo' }, user:) }
  let(:second_search) { Search.create!(model:, filters: { email: 'bar' }, user:) }

  before { [first_search, second_search] }

  describe '.call' do
    subject { query.call(model, name) }

    it { is_expected.to eq(%w[bar foo]) }
  end
end
