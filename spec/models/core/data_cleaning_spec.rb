# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataCleaning do
  include Schematics::Specs::Model
  include ActiveSupport::Testing::TimeHelpers

  before { freeze_time }

  its(:model_class) { is_expected.to eq(Team) }
  its(:query_method) { is_expected.to eq(:destroy!) }
  its(:query_field) { is_expected.to eq(:deadline) }
  its(:query_range) { is_expected.to eq(..1.hour.ago) }

  describe '.internal' do
    subject { described_class.internal }

    it { is_expected.to all(be_a(described_class)) }
  end
end
