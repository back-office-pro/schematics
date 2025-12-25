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

RSpec.describe Chart do
  include Schematics::Specs::Model

  it { is_expected.to be_a(Schematics::Measurable) }

  its(:border_width) { is_expected.to eq(1) }
  its(:col_size) { is_expected.to eq(3) }
  its(:max_col_size) { is_expected.to eq(6) }
  its(:filename) { is_expected.to eq('count-of-users-per-identifier-since-one-minute') }
  its(:icon) { is_expected.to eq(:chart_line) }
  its(:model_class) { is_expected.to eq(User) }
  its(:suffix) { is_expected.to be_nil }
  its(:to_s) { is_expected.to eq('Count of users per identifier since one minute') }
  its(:type) { is_expected.to eq(:line_chart) }
  its(:xtitle) { is_expected.to eq('Identifier') }
  its(:ytitle) { is_expected.to eq('Count of users') }
  its(:serialized_json) { is_expected.to be_empty }
  its(:cached_serialized_json) { is_expected.to be_empty }
  its(:color) { is_expected.to eq('#000000') }
  its(:colors) { is_expected.to be_all('#000000') }

  context 'when model_class does not exist' do
    before { record.model = 'NotExistingModel' }

    its(:icon) { is_expected.to eq(:triangle_exclamation) }
    its(:model_class) { is_expected.to be_nil }
    its(:serialized_json) { is_expected.to be_nil }
    its(:cached_serialized_json) { is_expected.to be_nil }
    its(:to_s) { is_expected.to eq('NotExistingModel is not defined') }
    its(:xtitle) { is_expected.to be_nil }
    its(:ytitle) { is_expected.to be_nil }
  end

  describe '.api' do
    subject { described_class.api }

    it { is_expected.to be_a(described_class) }
    its(:model) { is_expected.to eq('APIRequest') }
  end
end
