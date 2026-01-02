# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Metric::Component, type: :component do
  subject { render_inline described_class.new(metric:) }

  include_context 'with user'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:metric) { Metric.create!(aggregate: 'count', model: 'Task', threshold:) }

  before { allow(vc_test_controller).to receive(:current_user).and_return(user) }

  context 'when threshold is not exceeded' do
    let(:threshold) { 10 }

    it { is_expected.to have_css('div', class: 'progress-bar bg-success') }
  end

  context 'when threshold is exceeded' do
    let(:threshold) { 0 }

    it { is_expected.to have_css('div', class: 'progress-bar bg-danger') }
  end

  context 'when there is no threshold' do
    let(:threshold) { nil }

    it { is_expected.to have_text('0') }
  end
end
