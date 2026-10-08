# frozen_string_literal: true

describe Schematics::Options::StateMachineEvent do
  subject { described_class.new(state_machine:, name:, icon:, color:, from:, to:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'task') }
  let(:state_machine) { Schematics::Attributes::StateMachine.new(entity:, name: 'state', options:) }
  let(:options) do
    {
      values: %w[pending in_progress completed aborted],
      events: [
        name: 'process',
        from: 'pending',
        to: 'in_progress'
      ]
    }
  end

  let(:name) { 'complete' }
  let(:from) { 'in_progress' }
  let(:to) { 'completed' }
  let(:icon) { 'check' }
  let(:color) { 'success' }

  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_valid }

  its(:suffixed_name) { is_expected.to eq('complete_state') }
  its(:action) { is_expected.to eq(:after_complete_event) }
  its(:icon) { is_expected.to eq(:check) }
  its(:color) { is_expected.to eq(:success) }
  its(:confirm) { is_expected.to be_falsy }
  its(:human) { is_expected.to eq('Complete') }
  its(:i18n_scope) { is_expected.to eq(:events) }
  its(:i18n_key) { is_expected.to eq('activerecord.events.task.complete') }

  its(:to_spec) do
    is_expected.to eq('A task has a **complete** event from *in progress* to *completed*')
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      event :complete, after_commit: :after_complete_event do
        transitions from: [:in_progress], to: :completed
      end
    RUBY
  end

  its(:trigger_to_str) do
    is_expected.to eq <<~RUBY
      def after_complete_event; end
    RUBY
  end

  context 'when event name is reserved' do
    let(:name) { 'aasm' }

    it { is_expected.not_to be_valid }
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
