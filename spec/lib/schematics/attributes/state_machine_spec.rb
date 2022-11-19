# frozen_string_literal: true

describe Schematics::Attributes::StateMachine do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'order') }
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
          to: 'closed',
          callback: '$in_stock = false'
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
          to: 'pending',
          callback: '$in_stock = true'
        }
      ]
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }
  it { is_expected.to be_readonly }

  its(:database_type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('state') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:recycle) }
  its(:default) { is_expected.to eq('pending') }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('orders.state') }
  its(:to_s) { is_expected.to eq('schema:order_state') }
  its(:search_data) { is_expected.to eq('state:') }

  its(:available_options) do
    is_expected.to include(
      Schematics::Options::Events,
      Schematics::Options::DirectAssignment
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      enum :state, {:pending=>0, :closed=>1, :refused=>2}, prefix: true, default: "pending"
      aasm column: :#{name}, enum: true, no_direct_assignment: true do
        state :pending, initial: true
        state :closed, :refused
        event :close, after_commit: :after_close do
          transitions from: [:pending], to: :closed
        end
        event :refuse, after_commit: :after_refuse do
          transitions from: [:pending], to: :refused
        end
        event :reopen, after_commit: :after_reopen do
          transitions from: [:closed, :refused], to: :pending
        end
      end
      def after_close
        self.in_stock = false
      rescue StandardError
      end
      def after_refuse; end
      def after_reopen
        self.in_stock = true
      rescue StandardError
      end
    RUBY
  end
end
