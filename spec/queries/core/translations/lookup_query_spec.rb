# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Translations::LookupQuery do
  subject(:query) { described_class }

  let(:locale) { 'en' }
  let(:first_translation) do
    Translation.create!(
      locale:,
      key: 'activerecord.attributes.schema_dataset.state',
      value: 'State'
    )
  end
  let(:second_translation) do
    Translation.create!(
      locale:,
      key: 'activerecord.attributes.schema_dataset.states.pending',
      value: 'Pending'
    )
  end
  let(:third_translation) do
    Translation.create!(
      locale:,
      key: 'activerecord.attributes.schema_dataset.states.in_progress',
      value: 'In progress'
    )
  end

  before { [first_translation, second_translation, third_translation] }

  describe '.call' do
    subject { query.call(locale, key) }

    context 'when key does not exist' do
      let(:key) { 'activerecord.attributes.schema_dataset.foo' }

      it { is_expected.to be_empty }
    end

    context 'when key is an attribute' do
      let(:key) { 'activerecord.attributes.schema_dataset.state' }
      let(:expected_data) { { 'activerecord.attributes.schema_dataset.state' => 'State' } }

      it { is_expected.to eq(expected_data) }
    end

    context 'when key is enum root' do
      let(:key) { 'activerecord.attributes.schema_dataset.states' }
      let(:expected_data) do
        {
          'activerecord.attributes.schema_dataset.states.in_progress' => 'In progress',
          'activerecord.attributes.schema_dataset.states.pending' => 'Pending'
        }
      end

      it { is_expected.to eq(expected_data) }
    end

    context 'when key is model root' do
      let(:key) { 'activerecord.attributes.schema_dataset' }
      let(:expected_data) do
        {
          'activerecord.attributes.schema_dataset.state' => 'State',
          'activerecord.attributes.schema_dataset.states.in_progress' => 'In progress',
          'activerecord.attributes.schema_dataset.states.pending' => 'Pending'
        }
      end

      it { is_expected.to eq(expected_data) }
    end
  end
end
