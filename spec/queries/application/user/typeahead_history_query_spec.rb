# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::User::TypeaheadHistoryQuery do
  subject(:query) { described_class }

  include_context 'with user'

  let(:model) { 'User' }
  let(:name) { 'email' }
  let(:searches) do
    [
      Search.create!(model:, filters: { email: 'foo' }, user:),
      Search.create!(model:, filters: { email: 'bar' }, user:)
    ]
  end

  before { searches }

  describe '.call' do
    subject { query.call(user.searches, model, name) }

    it { is_expected.to eq(%w[bar foo]) }
  end
end
