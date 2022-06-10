# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MainApp::User::SearchHistoryQuery do
  subject(:query) { described_class }

  include_context 'with user'

  let(:searches) do
    [
      Search.create!(query: 'foo', user:),
      Search.create!(query: 'bar', user:)
    ]
  end

  before { searches }

  describe '.call' do
    subject { query.call(user.searches) }

    it { is_expected.to eq(%w[bar foo]) }
  end
end
