# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SearchIndex do
  include_context 'with user'

  describe '.insert_sql' do
    subject(:call) { described_class.insert_sql(**values) }

    let(:values) do
      {
        content: 'john.doe@nowhere.com John Doe',
        searchable_type: 'User',
        searchable_id: user.id
      }
    end

    it 'inserts a new search index' do
      expect { call }
        .to change(described_class, :count)
        .from(0)
        .to(1)
    end
  end
end
