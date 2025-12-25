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

RSpec.describe OpenAPI::Components::Parameter do
  subject { described_class.new(name:, in:, type:, description:) }

  let(:name) { 'page' }
  let(:type) { 'integer' }
  let(:in) { 'query' }
  let(:description) { 'Current page' }
  let(:expected_hash) do
    {
      description:,
      in:,
      name:,
      required: false,
      schema: { description:, type: }
    }
  end

  its(:to_h) { is_expected.to eq(expected_hash) }

  describe '.id' do
    subject { described_class.id }

    let(:expected_hash) do
      {
        in: 'path',
        name: 'id',
        required: false,
        schema: { type: 'string' }
      }
    end

    its(:to_h) { is_expected.to eq(expected_hash) }
  end
end
