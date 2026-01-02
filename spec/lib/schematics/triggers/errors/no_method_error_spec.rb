# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Triggers::Errors::NoMethodError do
  subject(:error) { described_class.new(exception) }

  let(:exception) { NoMethodError.new(nil, 'foo_formatted', receiver:) }
  let(:receiver) { nil }

  its(:name) { is_expected.to eq('foo') }

  context 'when there is no receiver' do
    its(:to_s) { is_expected.to eq('a variable does not have value') }
  end

  context 'when there is a receiver' do
    let(:receiver) { 'bar' }

    its(:to_s) { is_expected.to eq('foo is not defined') }
  end
end
