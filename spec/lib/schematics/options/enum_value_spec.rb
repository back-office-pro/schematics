# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::EnumValue do
  subject { described_class.new(enum:, value: 'completed') }

  let(:entity) { Schematics::Entities::Entity.new(name: 'task') }
  let(:enum) { Schematics::Attributes::Enum.new(entity:, name: 'state') }

  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_valid }

  its(:name) { is_expected.to eq('state') }
  its(:id) { is_expected.to eq('activerecord.enums.task.state.completed') }
  its(:i18n_scope) { is_expected.to eq(:enums) }
  its(:i18n_key) { is_expected.to eq('activerecord.enums.task.state.completed') }
end
