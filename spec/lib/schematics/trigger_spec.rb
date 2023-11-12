# frozen_string_literal: true

describe Schematics::Trigger do
  subject { described_class.new(entity:, action:, callback:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'task') }

  before { allow(SecureRandom).to receive(:uuid).and_return('abcd-123e') }

  context 'when trigger is coming from state machine' do
    let(:action) { 'after_close_event' }
    let(:callback) { '$in_stock = true' }

    its(:method_name) { is_expected.to eq(:after_close_event_abcd_123e) }

    its(:to_spec) do
      is_expected.to eq <<~TEXT.chomp
        A task has a **after close event** trigger which function is `$in_stock = true`
      TEXT
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        def after_close_event
          self.in_stock = true
          save!
        rescue StandardError
        end
      RUBY
    end
  end

  context 'when trigger is a model callback' do
    let(:callback) { '$in_stock = true' }

    context 'when action is after_create' do
      let(:action) { 'after_create' }

      its(:method_name) { is_expected.to eq(:after_create_abcd_123e) }

      its(:to_spec) do
        is_expected.to eq <<~TEXT.chomp
          A task has a **after creation** trigger which function is `$in_stock = true`
        TEXT
      end

      its(:to_str) do
        is_expected.to eq <<~RUBY
          after_create :after_create_abcd_123e
          def after_create_abcd_123e
            self.in_stock = true
            save!
          rescue StandardError
          end
        RUBY
      end
    end

    context 'when action is before_create' do
      let(:action) { 'before_create' }

      its(:method_name) { is_expected.to eq(:before_create_abcd_123e) }

      its(:to_spec) do
        is_expected.to eq <<~TEXT.chomp
          A task has a **before creation** trigger which function is `$in_stock = true`
        TEXT
      end

      its(:to_str) do
        is_expected.to eq <<~RUBY
          before_create :before_create_abcd_123e
          def before_create_abcd_123e
            self.in_stock = true
          rescue StandardError
          end
        RUBY
      end
    end
  end
end
