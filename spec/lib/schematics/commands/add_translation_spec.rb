# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Commands::AddTranslation do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { Schematics::Attributes::String.new(entity:, name: 'name') }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Add a translation to **client**') }
  its(:weight) { is_expected.to eq(3) }

  context 'when attribute is an enum value' do
    let(:enum) { Schematics::Attributes::Enum.new(entity:, name: 'state') }
    let(:attribute) { Schematics::Options::EnumValue.new(enum:, value: 'completed') }

    its(:to_spec) { is_expected.to eq('Add a translation to **client**') }
  end

  describe '#generators' do
    subject { command.generators }

    context 'when attribute is not a state machine event' do
      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.name',
          behavior: :invoke
        )
      end
    end

    context 'when attribute is a state machine event' do
      let(:state_machine) { Schematics::Attributes::StateMachine.new(entity:, name: 'state') }
      let(:attribute) { Schematics::Options::StateMachineEvent.new(state_machine:, name: 'follow') }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.events.client.follow',
          behavior: :invoke
        )
      end
    end
  end
end
