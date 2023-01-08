# frozen_string_literal: true

describe Schematics::Trigger do
  subject { described_class.new(action:, callback:) }

  before { allow(SecureRandom).to receive(:uuid).and_return('abcd-123') }

  context 'when trigger is coming from state machine' do
    let(:action) { 'after_close' }
    let(:callback) { '$in_stock = true' }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        def after_close
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

      its(:to_str) do
        is_expected.to eq <<~RUBY
          after_create :after_create_abcd_123
          def after_create_abcd_123
            self.in_stock = true
            save!
          rescue StandardError
          end
        RUBY
      end
    end

    context 'when action is before_create' do
      let(:action) { 'before_create' }

      its(:to_str) do
        is_expected.to eq <<~RUBY
          before_create :before_create_abcd_123
          def before_create_abcd_123
            self.in_stock = true
          rescue StandardError
          end
        RUBY
      end
    end
  end
end
