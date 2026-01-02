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

RSpec.describe Schematics::CSVSerializer do
  subject(:serializer) { described_class.new(resources, preferences) }

  let(:preferences) { {} }
  let(:resources) do
    [
      Metric.new(aggregate: 'count', model: 'User', field: 'User#email'),
      Metric.new(aggregate: 'count', model: 'User', field: 'User#email')
    ]
  end

  its(:file) { is_expected.to be_a(Tempfile) }
  its(:filename) { is_expected.to eq('metrics.csv') }
  its(:extension) { is_expected.to eq(:csv) }
  its(:content_type) { is_expected.to eq('text/csv') }

  its(:content) do
    is_expected.to eq <<~CSV
      Aggregate,Data,Field,Period,Comparator,Alert threshold,Creation date
      Count,User,Email,"",Equal to,"",""
      Count,User,Email,"",Equal to,"",""
    CSV
  end

  context 'with preferences' do
    let(:preferences) { { "col_#{entity_id}_#{field_id}" => false } }
    let(:entity_id) { Metric.entity.id }
    let(:field_id) { Metric.entity.find_field_by_name('field').id }

    its(:content) do
      is_expected.to eq <<~CSV
        Aggregate,Data,Period,Comparator,Alert threshold,Creation date
        Count,User,"",Equal to,"",""
        Count,User,"",Equal to,"",""
      CSV
    end
  end
end
