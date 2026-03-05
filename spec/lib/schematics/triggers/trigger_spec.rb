# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Triggers::Trigger do
  subject { described_class.new(id:, entity:, action:, callback:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'task') }
  let(:callback) { '$in_stock = true' }
  let(:id) { '10ee534b-896e-4fc9-9070-ff060500c614' }

  context 'when trigger is coming from state machine' do
    let(:action) { 'after_close_event' }

    its(:method_name) { is_expected.to eq(:after_close_event_10ee534b_896e_4fc9_9070_ff060500c614) }

    its(:to_spec) do
      is_expected.to eq <<~TEXT.chomp
        A task has a **after close** trigger which function is `$in_stock = true`
      TEXT
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        def after_close_event
          self.in_stock = true
          save
        rescue StandardError => e
          raise Triggers::Errors::StandardError, Triggers::Errors::StandardError.build(e)
        end
      RUBY
    end
  end

  context 'when trigger is a model callback and action is after_create' do
    let(:action) { 'after_create' }

    its(:method_name) { is_expected.to eq(:after_create_10ee534b_896e_4fc9_9070_ff060500c614) }

    its(:to_spec) do
      is_expected.to eq <<~TEXT.chomp
        A task has a **after creation** trigger which function is `$in_stock = true`
      TEXT
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        after_create_commit :after_create_10ee534b_896e_4fc9_9070_ff060500c614
        def after_create_10ee534b_896e_4fc9_9070_ff060500c614
          self.in_stock = true
          save
        rescue StandardError => e
          raise Triggers::Errors::StandardError, Triggers::Errors::StandardError.build(e)
        end
      RUBY
    end
  end

  context 'when trigger is a model callback and action is before_create' do
    let(:action) { 'before_create' }

    its(:method_name) { is_expected.to eq(:before_create_10ee534b_896e_4fc9_9070_ff060500c614) }

    its(:to_spec) do
      is_expected.to eq <<~TEXT.chomp
        A task has a **before creation** trigger which function is `$in_stock = true`
      TEXT
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        before_create :before_create_10ee534b_896e_4fc9_9070_ff060500c614
        def before_create_10ee534b_896e_4fc9_9070_ff060500c614
          self.in_stock = true
        rescue StandardError => e
          raise Triggers::Errors::StandardError, Triggers::Errors::StandardError.build(e)
        end
      RUBY
    end
  end
end
