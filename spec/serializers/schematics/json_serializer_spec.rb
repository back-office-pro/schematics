# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::JsonSerializer do
  subject(:serializer) { UserSerializer.new(user, template:) }

  include_context 'with user'

  before do
    stub_const('UserSerializer', Class.new(ActiveModel::Serializer))
    UserSerializer.include(described_class)
  end

  describe '#serializable_hash' do
    subject { serializer.serializable_hash }

    context 'when template is show' do
      let(:template) { 'show' }

      it { is_expected.to include(id: be_a(String)) }
      it { is_expected.to include(email: be_a(String)) }
      it { is_expected.to include(first_name: be_a(String)) }
      it { is_expected.to include(last_name: be_a(String)) }
      it { is_expected.to include(locale: 'fr') }
      it { is_expected.to include(time_zone: 'UTC') }
      it { is_expected.to include(full_name: be_a(String)) }
      it { is_expected.to include(:searches) }
      it { is_expected.to include(:imports) }
      it { is_expected.to include(:sent_messages) }
    end

    context 'when template is index' do
      let(:template) { 'index' }

      it { is_expected.to include(id: be_a(String)) }
      it { is_expected.to include(email: be_a(String)) }
      it { is_expected.to include(first_name: be_a(String)) }
      it { is_expected.to include(last_name: be_a(String)) }
      it { is_expected.to include(locale: 'fr') }
      it { is_expected.to include(time_zone: 'UTC') }
      it { is_expected.to include(full_name: be_a(String)) }
      it { is_expected.not_to include(:searches) }
      it { is_expected.not_to include(:imports) }
      it { is_expected.not_to include(:sent_messages) }
    end
  end
end
