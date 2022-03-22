# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CsvSerializer do
  subject(:serializer) { described_class.new(model_class, resources, preferences) }

  fixtures :stats

  let(:model_class) { Stat }
  let(:resources) { model_class.all }

  before { Stat.update(model: 'User', field: 'User#email') }

  describe '#generate_file' do
    subject { serializer.generate_file }

    context 'without preferences' do
      let(:preferences) { {} }
      let(:expected_content) do
        <<~CSV
          Data,Agregate,Field
          User,Count,Email
          User,Count,Email
        CSV
      end

      it { is_expected.to eq(expected_content) }
    end

    context 'with preferences' do
      let(:preferences) { { 'col_stat_field' => false } }
      let(:expected_content) do
        <<~CSV
          Data,Agregate
          User,Count
          User,Count
        CSV
      end

      it { is_expected.to eq(expected_content) }
    end
  end
end
