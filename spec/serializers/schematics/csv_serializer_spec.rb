# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CsvSerializer do
  subject(:serializer) { described_class.new(resources, preferences) }

  fixtures :stats

  let(:resources) { Stat.all }
  let(:preferences) { {} }

  before { Stat.update_all(model: 'User', field: 'User#email') } # rubocop:disable Rails/SkipsModelValidations

  its(:file) { is_expected.to be_a(Tempfile) }
  its(:filename) { is_expected.to eq('stats.csv') }

  its(:content) do
    is_expected.to eq <<~CSV
      Agregate,Data,Field
      Count,User,Email
      Count,User,Email
    CSV
  end

  context 'with preferences' do
    let(:preferences) { { 'col_stat_field' => false } }

    its(:content) do
      is_expected.to eq <<~CSV
        Agregate,Data
        Count,User
        Count,User
      CSV
    end
  end
end
