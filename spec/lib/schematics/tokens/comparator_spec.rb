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

describe Schematics::Tokens::Comparator do
  subject(:token) { described_class.new(value) }

  context 'when comparator is equal' do
    let(:value) { ' == ' }

    its(:to_sql) { is_expected.to eq(' = ') }
    its(:value) { is_expected.to eq(' == ') }
  end

  context 'when comparator is not equal' do
    let(:value) { ' != ' }

    its(:to_sql) { is_expected.to eq(' != ') }
    its(:value) { is_expected.to eq(' != ') }
  end

  context 'when comparator is equal NULL' do
    let(:value) { ' == NULL ' }

    its(:to_sql) { is_expected.to eq(' IS NULL') }
    its(:value) { is_expected.to eq(' == nil ') }
  end

  context 'when comparator is not equal NULL' do
    let(:value) { ' != NULL ' }

    its(:to_sql) { is_expected.to eq(' IS NOT NULL') }
    its(:value) { is_expected.to eq(' != nil ') }
  end
end
