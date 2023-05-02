# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Searches::HistoryQuery do
  include_context 'with user'

  let(:first_search) { Core::Search.create!(query: 'foo', user:) }
  let(:second_search) { Core::Search.create!(query: 'bar', user:) }

  before { [first_search, second_search] }

  its(:call) { is_expected.to eq(%w[bar foo]) }
end
