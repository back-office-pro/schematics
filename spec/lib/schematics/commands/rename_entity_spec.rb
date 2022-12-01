# frozen_string_literal: true

describe Schematics::Commands::RenameEntity do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'prospect') }
  let(:attribute) { 'client' }
  let(:target) { nil }

  before do
    allow(ActiveRecord::Base)
      .to receive_message_chain(:connection, :valid_type?) # rubocop:disable RSpec/MessageChain
      .and_return(true)
  end

  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    context 'when building' do
      let(:target) { :build }

      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([1]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
      its([2]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
      its([3]) { is_expected.to be_a(TranslationsGenerator) }
      its([4]) { is_expected.to be_a(PermissionsGenerator) }
    end

    context 'when cleaning' do
      let(:target) { :clean }

      its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
      its([1]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
    end
  end
end
