# frozen_string_literal: true

describe Schematics::Attributes::StateMachine do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'order') }
  let(:name) { 'state' }
  let(:options) do
    {
      default: 'pending',
      values: %w[
        pending
        closed
        refused
      ],
      events: [
        {
          name: 'close',
          from: 'pending',
          to: 'closed'
        },
        {
          name: 'refuse',
          from: 'pending',
          to: 'refused'
        },
        {
          name: 'reopen',
          from: %w[
            closed
            refused
          ],
          to: 'pending'
        }
      ]
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }
  it { is_expected.to be_readonly }

  its(:type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('state') }
  its(:icon) { is_expected.to eq(:recycle) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:default) { is_expected.to eq('pending') }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('orders.state') }
  its(:to_s) { is_expected.to eq('schema:order_state') }
  its(:search_data) { is_expected.to eq('state') }
  its(:options_for_migration) { is_expected.to be_empty }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      enum state: {:pending=>0, :closed=>1, :refused=>2}, _prefix: true, _default: "pending"
      aasm column: :#{name}, no_direct_assignment: true, whiny_transitions: false do
        state :pending, initial: true
        state :closed, :refused

        event :close do
          transitions from: [:pending], to: :closed
        end
        event :refuse do
          transitions from: [:pending], to: :refused
        end
        event :reopen do
          transitions from: [:closed, :refused], to: :pending
        end
      end
    RUBY
  end
end
