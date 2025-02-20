# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Searches::HistoryQuery do
  include_context 'with user'

  let(:first_search) { Search.create!(query: 'foo', user:) }
  let(:second_search) { Search.create!(query: 'bar', user:) }

  before { [first_search, second_search] }

  its(:call) { is_expected.to eq(%w[bar foo]) }
end
