# frozen_string_literal: true

describe Schematics::Options::StateMachineEvent do
  subject { described_class.new(state_machine:, name:, icon:, color:, from:, to:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'task') }
  let(:state_machine) { Schematics::Attributes::StateMachine.new(entity:, name: 'state', options:) }
  let(:options) do
    {
      values: %w[pending in_progress completed aborted],
      events: [
        {
          name: 'process',
          from: 'pending',
          to: 'in_progress'
        }
      ]
    }
  end

  let(:name) { 'complete' }
  let(:from) { 'in_progress' }
  let(:to) { 'completed' }
  let(:icon) { 'check' }
  let(:color) { 'success' }

  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_valid }

  its(:action) { is_expected.to eq(:after_complete) }
  its(:icon) { is_expected.to eq(:check) }
  its(:color) { is_expected.to eq(:success) }
  its(:human) { is_expected.to eq('Complete') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      event :complete, after_commit: :after_complete do
        transitions from: [:in_progress], to: :completed
      end
    RUBY
  end

  its(:trigger_to_str) do
    is_expected.to eq <<~RUBY
      def after_complete; end
    RUBY
  end

  context 'when event name is dangerous' do
    let(:name) { 'association' }

    it { is_expected.not_to be_valid }
  end

  context 'when event name is already taken' do
    let(:name) { 'process' }

    it { is_expected.not_to be_valid }
  end
end
