# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Translation::LookupQuery do
  subject(:query) { described_class }

  let(:locale) { 'en' }
  let(:first_translation) do
    Translation.create!(
      locale:,
      key: 'activerecord.attributes.user.first_name',
      value: 'First name'
    )
  end
  let(:second_translation) do
    Translation.create!(
      locale:,
      key: 'activerecord.attributes.user.last_name',
      value: 'Last name'
    )
  end

  before { [first_translation, second_translation] }

  describe '.call' do
    subject { query.call(locale, key) }

    context 'when key does not exist' do
      let(:key) { 'activerecord.attributes.user.foo' }

      it { is_expected.to be_empty }
    end

    context 'when key is not root' do
      let(:key) { 'activerecord.attributes.user.first_name' }

      it { is_expected.to eq(first_name: 'First name') }
    end

    context 'when key is root' do
      let(:key) { 'activerecord.attributes.user' }

      it { is_expected.to eq(first_name: 'First name', last_name: 'Last name') }
    end
  end
end
