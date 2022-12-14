# frozen_string_literal: true

describe Schematics::Tokens::Variable do
  subject(:token) { described_class.new(value, table_name) }

  let(:table_name) { 'entities' }

  context 'when there is no reference' do
    let(:value) { 'type' }

    its(:value) { is_expected.to eq('self.type') }
    its(:to_sql) { is_expected.to eq('entities.type') }
    its(:to_str) { is_expected.to eq('#{type_formatted}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when there is some reference' do
    let(:value) { 'schema.title' }

    its(:value) { is_expected.to eq('self.schema.title') }
    its(:to_sql) { is_expected.to eq('schemas.title') }
    its(:to_str) { is_expected.to eq('#{schema.title_formatted}') } # rubocop:disable Lint/InterpolationCheck
  end
end
