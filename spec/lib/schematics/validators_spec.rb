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

describe Schematics::Validators do
  subject { described_class.new(name:, validators:) }

  let(:name) { 'avatar' }

  context 'when validators are empty' do
    let(:validators) { {} }

    its(:compact_validators) { is_expected.to be_empty }
    its(:to_str) { is_expected.to be_blank }
    its(:human) { is_expected.to be_empty }
  end

  context 'when there are validators' do
    let(:validators) do
      {
        attached: true,
        size: {
          less_than: 2.megabytes,
          greater_than: nil
        }
      }
    end

    its(:compact_validators) do
      is_expected.to eq(attached: true, size: { less_than: 2.megabytes })
    end

    its(:human) do
      is_expected.to eq(
        [
          'File size Less than 2 MB'
        ]
      )
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        validates :avatar, {:attached=>true, :size=>{:less_than=>2097152}}
      RUBY
    end
  end
end
