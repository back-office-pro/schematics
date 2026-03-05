# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Attributes::StateMachine do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'order') }
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

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Generatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }
  it { is_expected.to be_readonly }

  its(:database_type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('state') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:input_name) { is_expected.to eq('order[state]') }
  its(:icon) { is_expected.to eq(:recycle) }
  its(:default) { is_expected.to eq('pending') }
  its(:search_column) { is_expected.to eq(:state) }
  its(:search_predicate) { is_expected.to eq(:in) }
  its(:search_query) { is_expected.to eq(:state_in) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('orders.state') }
  its(:to_s) { is_expected.to eq('state:integer:index') }
  its(:to_spec) { is_expected.to eq('A order has a **state** attribute of type *state machine*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.order.state') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a state machine') }
  its(:enum_type) { is_expected.to eq('OrderState') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Values,
      Schematics::Options::Events,
      Schematics::Options::DirectAssignment
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      enum :state,
           {:pending=>0, :closed=>1, :refused=>2},
           prefix: true,
           validate: { allow_blank: true },
           default: "pending"
      aasm :state, column: :state, enum: true, namespace: :state, create_scopes: false, no_direct_assignment: true do
        state :pending, initial: true
        state :closed
        state :refused
        event :close, after_commit: :after_close_event do
          transitions from: [:pending], to: :closed
        end
        event :refuse, after_commit: :after_refuse_event do
          transitions from: [:pending], to: :refused
        end
        event :reopen, after_commit: :after_reopen_event do
          transitions from: [:closed, :refused], to: :pending
        end
      end
      def after_close_event
        self.in_stock = false
        save
      rescue StandardError => e
        raise Triggers::Errors::StandardError, Triggers::Errors::StandardError.build(e)
      end
      def after_refuse_event; end
      def after_reopen_event
        self.in_stock = true
        save
      rescue StandardError => e
        raise Triggers::Errors::StandardError, Triggers::Errors::StandardError.build(e)
      end
    RUBY
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      state_machine: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a state machine',
            enum: %w[state_machine]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/values' },
              { '$ref': '#/$defs/events' }
            ]
          }
        }
      }
    )
  end

  context 'when there is only one value' do
    let(:options) { { values: ['pending'] } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        enum :state,
             {:pending=>0},
             prefix: true,
             validate: { allow_blank: true }
        aasm :state, column: :state, enum: true, namespace: :state, create_scopes: false, no_direct_assignment: true do
          state :pending, initial: true
        end
      RUBY
    end
  end

  context 'when there is no value' do
    let(:options) { {} }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        enum :state, prefix: true, validate: { allow_blank: true }
        aasm :state, column: :state, enum: true, namespace: :state, create_scopes: false, no_direct_assignment: true do
        end
      RUBY
    end
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Enum,
        Schematics::Attributes::Flag
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
