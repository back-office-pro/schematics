# frozen_string_literal: true

describe Schematics::Tokens::Function do
  subject(:token) { described_class.new(value) }

  let(:value) { nil }

  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  context 'when function is NOW' do
    let(:value) { 'NOW()' }

    its(:value) { is_expected.to eq('Time.current') }
    its(:to_sql) { is_expected.to eq('NOW()') }
    its(:to_str) { is_expected.to eq('#{Time.current}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is RAND' do
    let(:value) { 'RAND()' }

    its(:value) { is_expected.to eq('rand') }
    its(:to_sql) { is_expected.to eq('RAND()') }
    its(:to_str) { is_expected.to eq('#{rand}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is SUM with reference' do
    let(:value) { 'SUM($parts.price)' }

    its(:value) { is_expected.to eq('parts.sum(&:price)') }
    its(:to_sql) { is_expected.to eq('SUM(parts.price)') }
    its(:to_str) { is_expected.to eq('#{parts.sum(&:price)}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is SUM without reference' do
    let(:value) { 'SUM($parts)' }

    its(:value) { is_expected.to eq('self.parts.sum') }
    its(:to_sql) { is_expected.to eq('SUM(parts)') }
    its(:to_str) { is_expected.to eq('#{self.parts.sum}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is AVG with reference' do
    let(:value) { 'AVG($parts.price)' }

    its(:value) { is_expected.to eq('parts.average(&:price)') }
    its(:to_sql) { is_expected.to eq('AVG(parts.price)') }
    its(:to_str) { is_expected.to eq('#{parts.average(&:price)}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is AVG without reference' do
    let(:value) { 'AVG($parts)' }

    its(:value) { is_expected.to eq('self.parts.avg') }
    its(:to_sql) { is_expected.to eq('AVG(parts)') }
    its(:to_str) { is_expected.to eq('#{self.parts.avg}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is MIN with reference' do
    let(:value) { 'MIN($parts.price)' }

    its(:value) { is_expected.to eq('parts.minimum(&:price)') }
    its(:to_sql) { is_expected.to eq('MIN(parts.price)') }
    its(:to_str) { is_expected.to eq('#{parts.minimum(&:price)}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is MIN without reference' do
    let(:value) { 'MIN($parts)' }

    its(:value) { is_expected.to eq('self.parts.min') }
    its(:to_sql) { is_expected.to eq('MIN(parts)') }
    its(:to_str) { is_expected.to eq('#{self.parts.min}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is MAX with reference' do
    let(:value) { 'MAX($parts.price)' }

    its(:value) { is_expected.to eq('parts.maximum(&:price)') }
    its(:to_sql) { is_expected.to eq('MAX(parts.price)') }
    its(:to_str) { is_expected.to eq('#{parts.maximum(&:price)}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is MAX without reference' do
    let(:value) { 'MAX($parts)' }

    its(:value) { is_expected.to eq('self.parts.max') }
    its(:to_sql) { is_expected.to eq('MAX(parts)') }
    its(:to_str) { is_expected.to eq('#{self.parts.max}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is COUNT with reference' do
    let(:value) { 'COUNT($parts.price)' }

    its(:value) { is_expected.to eq('parts.count(&:price)') }
    its(:to_sql) { is_expected.to eq('COUNT(parts.price)') }
    its(:to_str) { is_expected.to eq('#{parts.count(&:price)}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is COUNT without reference' do
    let(:value) { 'COUNT($parts)' }

    its(:value) { is_expected.to eq('self.parts.count') }
    its(:to_sql) { is_expected.to eq('COUNT(parts)') }
    its(:to_str) { is_expected.to eq('#{self.parts.count}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is ABS' do
    let(:value) { 'ABS($price)' }

    its(:value) { is_expected.to eq('self.price.abs') }
    its(:to_sql) { is_expected.to eq('ABS(price)') }
    its(:to_str) { is_expected.to eq('#{self.price.abs}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is ROUND' do
    let(:value) { 'ROUND($price)' }

    its(:value) { is_expected.to eq('self.price.round') }
    its(:to_sql) { is_expected.to eq('ROUND(price)') }
    its(:to_str) { is_expected.to eq('#{self.price.round}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is CEIL' do
    let(:value) { 'CEIL($price)' }

    its(:value) { is_expected.to eq('self.price.ceil') }
    its(:to_sql) { is_expected.to eq('CEIL(price)') }
    its(:to_str) { is_expected.to eq('#{self.price.ceil}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is FLOOR' do
    let(:value) { 'FLOOR($price)' }

    its(:value) { is_expected.to eq('self.price.floor') }
    its(:to_sql) { is_expected.to eq('FLOOR(price)') }
    its(:to_str) { is_expected.to eq('#{self.price.floor}') } # rubocop:disable Lint/InterpolationCheck
  end
end
