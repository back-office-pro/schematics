# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Entities::Singleton do
  subject(:entity) { described_class.new(schema:, name:, attributes:) }

  let(:schema) { Schematics::Schema.new }
  let(:name) { 'configuration' }
  let(:attributes) do
    [
      name: 'company_name',
      type: 'string'
    ]
  end

  its(:actions) { is_expected.to eq(%i[show update]) }

  its('model_elements.last') do
    is_expected.to eq <<~RUBY
      include Schematics::Singleton
    RUBY
  end
end
