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
