# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription do
  include Schematics::Specs::Model

  include_context 'with stripe stubs'

  describe '#load!' do
    subject(:load!) { record.load! }

    before { record.state_inactive! }

    it 'updates subscription state' do
      expect { load! }
        .to change(record, :state)
        .from('inactive')
        .to('active')
    end
  end
end
