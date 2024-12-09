# frozen_string_literal: true

describe Schematics::Tokens::Variable do
  subject(:token) { described_class.new(value, table_name) }

  let(:table_name) { 'entities' }
  let(:value) { nil }

  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  context 'when there is no reference' do
    let(:value) { 'type' }

    it { is_expected.not_to be_with_references }

    its(:value) { is_expected.to eq('self.type') }
    its(:raw_value) { is_expected.to eq('type') }
    its(:to_sql) { is_expected.to eq('entities.type') }
    its(:to_str) { is_expected.to eq('#{type_formatted}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when there is some reference' do
    let(:value) { 'schema.title' }

    it { is_expected.to be_with_references }

    its(:value) { is_expected.to eq('self.schema&.title') }
    its(:raw_value) { is_expected.to eq('title') }
    its(:to_sql) { is_expected.to eq('schemas.title') }
    its(:to_str) { is_expected.to eq('#{schema&.title_formatted}') } # rubocop:disable Lint/InterpolationCheck
  end

  describe '#fn_value' do
    subject(:fn_value) { token.fn_value(name) }

    let(:name) { :sum }

    context 'when there is no reference' do
      let(:value) { 'type' }

      it { is_expected.to eq('self.type&.sum') }
    end

    context 'when there is some reference' do
      let(:value) { 'schema.title' }

      it { is_expected.to eq('schema.sum(&:title)') }
    end
  end
end
