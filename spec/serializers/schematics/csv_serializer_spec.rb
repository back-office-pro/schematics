# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CsvSerializer do
  subject(:serializer) { described_class.new(model_class, resources, preferences) }

  fixtures :stats

  let(:model_class) { Stat }
  let(:resources) { model_class.all }

  before { Stat.update_all(model: 'User', field: 'User#email') } # rubocop:disable Rails/SkipsModelValidations

  describe '#generate_file' do
    subject { serializer.generate_file }

    context 'without preferences' do
      let(:preferences) { {} }
      let(:expected_content) do
        <<~CSV
          Agregate,Data,Field
          Count,User,Email
          Count,User,Email
        CSV
      end

      it { is_expected.to eq(expected_content) }
    end

    context 'with preferences' do
      let(:preferences) { { 'col_stat_field' => false } }
      let(:expected_content) do
        <<~CSV
          Agregate,Data
          Count,User
          Count,User
        CSV
      end

      it { is_expected.to eq(expected_content) }
    end
  end
end
