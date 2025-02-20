# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Translations::LookupQuery do
  subject(:query) { described_class }

  let(:locale) { 'en' }
  let(:first_translation) do
    Translation.create!(
      locale:,
      key: 'activerecord.attributes.migration.state',
      value: 'State'
    )
  end
  let(:second_translation) do
    Translation.create!(
      locale:,
      key: 'activerecord.enums.migration.state.pending',
      value: 'Pending'
    )
  end
  let(:third_translation) do
    Translation.create!(
      locale:,
      key: 'activerecord.enums.migration.state.in_progress',
      value: 'In progress'
    )
  end

  before { [first_translation, second_translation, third_translation] }

  describe '.call' do
    subject { query.call(locale, key) }

    context 'when key does not exist' do
      let(:key) { 'activerecord.attributes.migration.sta' }

      it { is_expected.to be_empty }
    end

    context 'when key is an attribute' do
      let(:key) { 'activerecord.attributes.migration.state' }
      let(:expected_data) { { 'activerecord.attributes.migration.state' => 'State' } }

      it { is_expected.to eq(expected_data) }
    end

    context 'when key is enum root' do
      let(:key) { 'activerecord.enums.migration.state' }
      let(:expected_data) do
        {
          'activerecord.enums.migration.state.in_progress' => 'In progress',
          'activerecord.enums.migration.state.pending' => 'Pending'
        }
      end

      it { is_expected.to eq(expected_data) }
    end

    context 'when key is root' do
      let(:key) { 'activerecord' }
      let(:expected_data) do
        {
          'activerecord.attributes.migration.state' => 'State',
          'activerecord.enums.migration.state.in_progress' => 'In progress',
          'activerecord.enums.migration.state.pending' => 'Pending'
        }
      end

      it { is_expected.to eq(expected_data) }
    end
  end
end
