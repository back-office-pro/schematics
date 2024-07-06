# frozen_string_literal: true

describe Schematics::Commands::RenameTranslation do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { Schematics::Attributes::String.new(entity:, name: 'surname') }
  let(:target) { Schematics::Attributes::String.new(entity:, name: 'name') }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Rename a **client** translation') }
  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    context 'when target is not a state machine event' do
      its([0]) { is_expected.to be_a(TranslationGenerator) }
      its([0]) { is_expected.to have_attributes(name: 'attributes.client.name') }
      its(:size) { is_expected.to eq(1) }
    end

    context 'when target is a state machine event' do
      let(:state_machine) { Schematics::Attributes::StateMachine.new(entity:, name: 'state') }
      let(:target) { Schematics::Options::StateMachineEvent.new(state_machine:, name: 'follow') }

      its([0]) { is_expected.to be_a(TranslationGenerator) }
      its([0]) { is_expected.to have_attributes(name: 'events.client.follow') }
      its(:size) { is_expected.to eq(1) }
    end
  end
end
